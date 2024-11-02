//
//  LoginResponse.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import Foundation

/// This struct is used for decoding login responses
struct LoginResponse: Codable {
    var data: DataClass?
    
    struct DataClass: Codable {
        let token: String
    }
}
