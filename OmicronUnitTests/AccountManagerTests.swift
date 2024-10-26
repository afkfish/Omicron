//
//  OmicronTests.swift
//  OmicronTests
//
//  Created by Beni Kis on 2024. 10. 24..
//

import Foundation
import Testing
@testable import Omicron

@Suite("Account operations")
struct AccountManagerTests {
    let accountManager = AccountManager(true)
    
    @Test("Account switching")
    func switchUser() async throws {
        let offlineAccount = try #require(accountManager.offlineAccount)
        accountManager.switchToAccount(offlineAccount)
        
        sleep(1)
        
        #expect(accountManager.currentAccount != nil)
    }
    
    @Test("Persistent storage")
    func persistence() async throws {
        let testUser = UserModelDTO(id: "12345", username: "test", email: "test@test.com", library: [], ratings: ["11111": 1], progresses: [:], version: 0).toUserModel()
        testUser.isOffline = true
        
        accountManager.offlineAccount = testUser
        accountManager.currentAccount = testUser
        
        accountManager.saveAccounts()
        
        accountManager.offlineAccount = nil
        accountManager.currentAccount = nil
        
        accountManager.loadAccounts()
        
        #expect(accountManager.currentAccount != nil && !accountManager.currentAccount!.ratings.isEmpty)
        #expect(accountManager.offlineAccount != nil && !accountManager.offlineAccount!.ratings.isEmpty)
    }
}
