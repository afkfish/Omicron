//
//  UserDTO.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import Foundation


struct User: Codable {
    var uid: String? = ""
    var username: String
    let email: String
    
    var lists: [String: [String]] = [:]
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.lists = ["favourites": []]
    }
}
