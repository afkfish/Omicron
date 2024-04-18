//
//  BaseDTO.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation

struct BaseDTO: Codable {
    let id: String
    let image: Image
    let title: String
    let year: Int
    
    struct Image: Codable {
        let url: String
    }
}
