//
//  firestore.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreData


// MARK: - Account Manager
class AccountManager: ObservableObject {
    @Published var currentAccount: UserModel?
    @Published var accounts: [UserModel] = []
    
    private let userDefaults = UserDefaults.standard
    private let firestore = Firestore.firestore()
    
    init() {
        loadAccounts()
    }
    
    func loadAccounts() {
        if let data = userDefaults.data(forKey: "userAccounts"),
           let accounts = try? JSONDecoder().decode([UserModel].self, from: data) {
            self.accounts = accounts
        }
        if let data = userDefaults.data(forKey: "currentAccount"),
           let currentAccount = try? JSONDecoder().decode(UserModel.self, from: data) {
            self.currentAccount = currentAccount
        }
    }
    
    func saveAccounts() {
        if let encoded = try? JSONEncoder().encode(accounts) {
            userDefaults.set(encoded, forKey: "userAccounts")
        }
        if let encoded = try? JSONEncoder().encode(currentAccount) {
            userDefaults.set(encoded, forKey: "currentAccount")
        }
    }
    
    func addAccount(_ account: UserModel) {
        accounts.append(account)
        saveAccounts()
    }
    
    func switchToAccount(_ account: UserModel) {
        currentAccount = account
        saveAccounts()
        // Implement logic to switch CoreData store and sync with Firestore if online
    }
    
    func createOfflineAccount(username: String) {
        let offlineAccount = UserModel(id: UUID().uuidString, username: username, email: "", isOffline: true)
        addAccount(offlineAccount)
        switchToAccount(offlineAccount)
    }
    
    func loginWithFirebase(email: String, password: String) async throws {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authResult.user
        let account = UserModel(id: user.uid, username: user.displayName ?? "", email: user.email ?? "", isOffline: false)
        addAccount(account)
        switchToAccount(account)
    }
}

// MARK: - Core Data Manager
class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    func createContainer(for accountId: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "UserDataModel")
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!.appendingPathComponent("\(accountId).sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }
}

// MARK: - Data Sync Manager
class DataSyncManager {
    private let firestore = Firestore.firestore()
    private let accountManager: AccountManager
    private let coreDataManager: CoreDataManager
    
    init(accountManager: AccountManager, coreDataManager: CoreDataManager) {
        self.accountManager = accountManager
        self.coreDataManager = coreDataManager
    }
    
    func syncData() {
        guard let account = accountManager.currentAccount, !account.isOffline else { return }
        
        // Implement sync logic here:
        // 1. Fetch changes from Firestore
        // 2. Update CoreData
        // 3. Push local changes to Firestore
    }
}



class FireStore {
    static let shared = FireStore()
    var user: User?
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getUserData() async throws -> User {
        let userRef = db.collection("users")
        
        if let user = Auth.auth().currentUser {
            var document = try await userRef.document(user.uid).getDocument(as: User.self)
            document.uid = user.uid
            self.user = document
            return document
        } else {
            throw FirebaseError.notAuthenticatedError
        }
    }
    
    func saveUser(uid: String, username: String, email: String) async throws {
        try db.collection("users").document(uid).setData(from: User(username: username, email: email))
    }
    
    func getUserLists() async throws -> [String: [String]] {
        let user = try await self.getUserData()
        return user.lists
    }
    
    func addList(_ list: [String: [String]]) async throws {
        let user = try await self.getUserData()
        var lists = user.lists
        lists.merge(list, uniquingKeysWith: {
            var result = Set($0)
            $1.forEach {item in
                result.insert(item)
            }
            return result.sorted()
        })
        try db.collection("users").document(user.uid!).setData(from: user)
    }
    
    func addToList(name: String, value: String) async throws {
        var user = try await self.getUserData()
        if let list = user.lists[name] {
            if (!list.contains(value)) {
                user.lists[name]!.append(value)
            }
        } else {
            try await addList([name: [value]])
        }
        
        try db.collection("users").document(user.uid!).setData(from: user)
    }
    
    func removeFromList(name: String = "favourites", value: String) async throws {
        var user = try await self.getUserData()
        if let list = user.lists[name] {
            if list.contains(value) {
                user.lists[name]!.removeAll(where: {$0 == value})
                try db.collection("users").document(user.uid!).setData(from: user)
            }
        }
    }
}

class AuthProvider: ObservableObject {
    @Published var loggedIn = false
    @Published var cancelledLogin = false
    
    static let shared = AuthProvider()
    private let auth = Auth.auth()
    private init() {}
    
    func register(username: String, email: String, password: String) async throws {
        let ref = try await auth.createUser(withEmail: email, password: password)
        try await FireStore.shared.saveUser(uid: ref.user.uid, username: username, email: email)
        try await AuthStore().save(data: AuthStore.AuthData(email: email, password: password, authenticated: true))
    }
    
    func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
        try await AuthStore().save(data: AuthStore.AuthData(email: email, password: password, authenticated: true))
    }
}

@MainActor
class AuthStore: ObservableObject {
    struct AuthData: Codable {
        var email: String = ""
        var password: String = ""
        var authenticated: Bool = false
    }
    @Published var data: AuthData = AuthData()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("auth.data")
    }


    func load() async throws {
        let task = Task<AuthData, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return AuthData()
            }
            let authData = try JSONDecoder().decode(AuthData.self, from: data)
            return authData
        }
        let data = try await task.value
        self.data = data
    }
    
    func save(data: AuthData) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(data)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
        
        self.data = data
    }
}
