//
//  CloudInteractionTests.swift
//  OmicronTests
//
//  Created by Beni Kis on 2024. 10. 25..
//

import Foundation
import Testing
@testable import Omicron

@Suite("Cloud interactions", .serialized)
struct CloudInteractionTests {
    let accountManager = AccountManager(true)
    
    @Test("Firebase login")
    func login() async throws {
        let (testUser, library) = try await accountManager.loginWithFirebase(email: "test@test.com", password: "testtest")
        
        try #require(testUser.id == "cjECBXrFhqdDN2wXgYCEjCH8nZ92")
        #expect(!library.isEmpty && library.contains("11111"))
    }
    
    @Test("Firebase registration")
    func register() async throws {
        let randomUsername = UUID().uuidString
        let randomPassword = UUID().uuidString
        let randomEmail = UUID().uuidString + "@test.com"
        
        let (testUser, _) = try await accountManager.registerWithFirebase(username: randomUsername, email: randomEmail, password: randomPassword)

        #expect(testUser.username == randomUsername)
        
        let onlineData = try await accountManager.syncDown(for: testUser.id)
        #expect(onlineData.0.library == testUser.library)
    }
    
    @Test("Cloud sync")
    func sync() async throws {
        let (testUser, _) = try await accountManager.loginWithFirebase(email: "test@test.com", password: "testtest")
        accountManager.currentAccount = testUser
        
        try #require(accountManager.currentAccount != nil && accountManager.currentAccount?.id == testUser.id)
        let randomShow = ShowModel(id: "11111", title: "testShow")
        accountManager.currentAccount?.library.append(randomShow)
        try await accountManager.syncUp()
        
        let (_, library) = try await accountManager.syncDown(for: testUser.id)
        #expect(library.contains(randomShow.id))
    }
}
