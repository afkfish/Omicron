//
//  AuthManager.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import Foundation

class Token {
    var id: UUID
    var value: String?
    var validUntil: Date
    
    var isValid: Bool {
        return ((value?.isEmpty) == nil && Date.now < validUntil)
    }
    
    init(id: UUID, value: String? = nil, validUntil: Date) {
        self.id = id
        self.value = value
        self.validUntil = validUntil
    }
}

actor AuthManager {
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?
    
    private var apiController = TVDbAPIController()

    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }

        guard let token = currentToken else {
            throw AuthError.missingToken
        }

        if token.isValid {
            return token
        }

        return try await refreshToken()
    }

    func refreshToken() async throws -> Token {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task { () throws -> Token in
            defer { refreshTask = nil }
            
            // Normally you'd make a network call here. Could look like this:
            // return await networking.refreshToken(withRefreshToken: token.refreshToken)
            
            apiController
            
            // I'm just generating a dummy token
            let tokenExpiresAt = Date().addingTimeInterval(10)
            let newToken = Token(id: UUID(), validUntil: tokenExpiresAt)
            currentToken = newToken
            
            return newToken
        }
        
        self.refreshTask = task
        
        return try await task.value
    }
}

enum AuthError: Error {
    case missingToken
}
