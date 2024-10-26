//
//  LoginViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/05/2024.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

class LoginRegisterViewModel: ObservableObject {
    private var apiController: APIController!
    private var accountManager: AccountManager!
    private var modelContainer: ModelContainer!
    
    func start(_ apiController: APIController, _ accountManager: AccountManager, _ modelContainer: ModelContainer) {
        self.apiController = apiController
        self.accountManager = accountManager
        self.modelContainer = modelContainer
    }
    
    func login(email: String, password: String) async throws {
        let (onlineUserModel, library) = try await accountManager.loginWithFirebase(email: email, password: password)
        accountManager.switchToAccount(onlineUserModel)
        try await accountManager.resolveLibrary(apiController, modelContainer, library, onlineUserModel)
    }
    
    func register(username: String, email: String, password: String) async throws {
        let (onlineUserModel, library) = try await accountManager.registerWithFirebase(username: username, email: email, password: password)
        accountManager.switchToAccount(onlineUserModel)
        try await accountManager.resolveLibrary(apiController, modelContainer, library, onlineUserModel)
    }
}
