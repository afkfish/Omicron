//
//  firestore.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftData

class AccountManager: ObservableObject {
    @Published var offlineAccount: UserModel?
    @Published var currentAccount: UserModel?
    @Published var isAuthenticating: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private var db = Firestore.firestore().collection("users")
    private let auth = Auth.auth()
    
    private var libraryManager: LibraryManager!
    
    init(_ testing: Bool = false) {
        loadAccounts()
        if offlineAccount == nil {
            createOfflineAccount(username: "Offline")
        }
        if testing {
            db = Firestore.firestore().collection("testing")
        }
    }
    
    func loadAccounts() {
        if let data = userDefaults.data(forKey: "currentAccount"),
           let currentAccount = try? JSONDecoder().decode(UserModel.self, from: data) {
            self.currentAccount = currentAccount
        }
        
        if let data = userDefaults.data(forKey: "offlineAccount"),
           let offlineAccount = try? JSONDecoder().decode(UserModel.self, from: data) {
            self.offlineAccount = offlineAccount
        }
    }
    
    func saveAccounts() {
        if let encoded = try? JSONEncoder().encode(currentAccount) {
            userDefaults.set(encoded, forKey: "currentAccount")
        }
        
        if let encoded = try? JSONEncoder().encode(offlineAccount) {
            userDefaults.set(encoded, forKey: "offlineAccount")
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(currentAccount) {
            userDefaults.set(encoded, forKey: "currentAccount")
        }
        
        if let isOffline = currentAccount?.isOffline, isOffline {
            if let encoded = try? JSONEncoder().encode(currentAccount) {
                userDefaults.set(encoded, forKey: "offlineAccount")
            }
        }
    }
    
    func switchToAccount(_ account: UserModel) {
        if Thread.isMainThread {
            currentAccount = account
            saveAccounts()
            self.isAuthenticating = false
        } else {
            DispatchQueue.main.async {
                self.currentAccount = account
                self.saveAccounts()
                self.isAuthenticating = false
            }
        }
    }
    
    private func createOfflineAccount(username: String) {
        guard self.offlineAccount == nil else { return }
        let offlineAccount = UserModel(id: UUID().uuidString, username: username, email: "", isOffline: true)
        self.offlineAccount = offlineAccount
    }
    
    func loginWithFirebase(email: String, password: String) async throws -> (UserModel, [String]) {
        DispatchQueue.main.async {
            self.isAuthenticating = true
        }
        let authResult = try await auth.signIn(withEmail: email, password: password)
        let user = authResult.user
        return try await syncDown(for: user.uid)
    }
    
    func registerWithFirebase(username: String, email: String, password: String) async throws -> (UserModel, [String]) {
        DispatchQueue.main.async {
            self.isAuthenticating = true
        }
        let authResult = try await auth.createUser(withEmail: email, password: password)
        let user = authResult.user
        let userModel = UserModelDTO(id: user.uid, username: username, email: email, library: [], ratings: [:], progresses: [:], version: 0)
        try db.document(user.uid).setData(from: userModel)
        return (userModel.toUserModel(), [])
    }
    
    func syncDown(for userId: String) async throws -> (UserModel, [String]) {
        let userModelDTO = try await db.document(userId).getDocument(as: UserModelDTO.self)
        return (userModelDTO.toUserModel(), userModelDTO.library)
    }
    
    func syncUp() async throws {
        guard let account = currentAccount, !account.isOffline else { return }
        try db.document(account.id).setData(from: UserModelDTO(from: account))
    }
    
    func refreshLibrary(_ apiController: APIController, _ modelContainer: ModelContainer) async throws {
        guard let user = currentAccount, !user.isOffline else { return }
        
        let (_, library) = try await syncDown(for: user.id)
        user.library = []
        
        try await resolveLibrary(apiController, modelContainer, library, user)
    }
    
    func resolveLibrary(_ apiController: APIController, _ modelContainer: ModelContainer, _ library: [String], _ user: UserModel) async throws {
        self.libraryManager = LibraryManager(modelContainer: modelContainer)
        
        let offlineResults = try await libraryManager.fetchOfflineShows(ids: library)
        let onlineResultsIds = library.filter { id in !offlineResults.contains { $0.id == id } }
        user.library.append(contentsOf: offlineResults)
        await apiController.getShows(ids: onlineResultsIds, addToLibrary)
    }
    
    private func addToLibrary(_ result: ShowModel?) {
        if let result = result {
            Task { [weak self] in
                guard let self else { return }
                await self.libraryManager.addToModelContext(result)
                self.currentAccount!.library.append(result)
            }
        }
    }
}
