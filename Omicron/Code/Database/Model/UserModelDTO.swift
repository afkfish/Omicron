//
//  UserModelDTO.swift
//  Omicron
//
//  Created by Beni Kis on 2024. 10. 14..
//

import Foundation

/// This struct is used to decode `UserModel` from the cloud database
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
    /// This initializer is to convert a `UserModel` to a `UserModelDTO` for the cloud
    init(from userModel: UserModel) {
        id = userModel.id
        username = userModel.username
        email = userModel.email
        library = userModel.library.map { $0.id }
        ratings = userModel.ratings
        progresses = userModel.progresses
        version = userModel.version
    }
    
    /// Converts a `UserModelDTO` to a `UserModel`
    func toUserModel() -> UserModel {
        .init(id: id, username: username, email: email, isOffline: false, library: [], ratings: ratings, progresses: progresses)
    }
}
