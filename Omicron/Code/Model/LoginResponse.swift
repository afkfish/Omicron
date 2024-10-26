//
//  LoginResponse.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import Foundation

struct LoginResponse: Codable {
    var data: DataClass?
    
    struct DataClass: Codable {
        let token: String
    }
}
