//
//  UserModelDTO.swift
//  Omicron
//
//  Created by Beni Kis on 2024. 10. 14..
//

import Foundation

public struct UserModelDTO: Codable {
    var id: String
    var username: String
    var email: String
    var library: [String]
    var ratings: [String: Int]
    var progresses: [String: [Int: Int]]
    var version: Int
}

// MARK: - Converter
extension UserModelDTO {
    init(from userModel: UserModel) {
        id = userModel.id
        username = userModel.username
        email = userModel.email
        library = userModel.library.map { $0.id }
        ratings = userModel.ratings
        progresses = userModel.progresses
        version = userModel.version
    }
    
    func toUserModel() -> UserModel {
        .init(id: id, username: username, email: email, isOffline: false, library: [], ratings: ratings, progresses: progresses)
    }
}
