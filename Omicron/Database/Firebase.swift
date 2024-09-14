//
//  firestore.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

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
