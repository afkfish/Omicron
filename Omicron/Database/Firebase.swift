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
    @Published var offlineAccount: UserModel?
    @Published var currentAccount: UserModel?
    
    private let userDefaults = UserDefaults.standard
    private let firestore = Firestore.firestore()
    
    init() {
        loadAccounts()
        if offlineAccount == nil {
            createOfflineAccount(username: "Offline")
        }
        if currentAccount == nil {
            currentAccount = offlineAccount
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
            if let encoded = try? JSONEncoder().encode(offlineAccount) {
                userDefaults.set(encoded, forKey: "offlineAccount")
            }
        }
    }
    
    func switchToAccount(_ account: UserModel) {
        currentAccount = account
        saveAccounts()
    }
    
    func createOfflineAccount(username: String) {
        guard self.offlineAccount == nil else { return }
        let offlineAccount = UserModel(id: UUID().uuidString, username: username, email: "", isOffline: true)
        self.offlineAccount = offlineAccount
        switchToAccount(offlineAccount)
    }
    
    func loginWithFirebase(email: String, password: String) async throws -> (UserModel, [String]) {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authResult.user
        return try await syncDown(for: user)
    }
    
    func syncDown(for user: User) async throws -> (UserModel, [String]) {
        let userModelDTO = try await firestore.collection("users").document(user.uid).getDocument(as: UserModelDTO.self)
        return (userModelDTO.toUserModel(), userModelDTO.library)
    }
    
    func syncUp() async throws {
        guard let account = currentAccount, !account.isOffline else { return }
        try firestore.collection("users").document(account.id).setData(from: UserModelDTO(from: account))
    }
}
