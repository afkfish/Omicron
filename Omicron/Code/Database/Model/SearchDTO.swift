//
//  SearchDTO.swift
//  Omicron
//
//  Created by Beni Kis on 28/03/2024.
//

import Foundation

/// This struct is used to decode search results of shows from the API
struct SearchDTO: Codable {
    var data: [SearchShow]?
    
    struct SearchShow: Codable {
        let id: String
        let country: String?
        let imageURL: String
        let overview: String?
        let firstAirTime: String?
        let name, primaryLanguage: String
        let status, tvdbID: String
        let year: String?
        let network: String?
        let thumbnail: String?
        
        enum CodingKeys: String, CodingKey {
            case country, id
            case imageURL = "image_url"
            case name
            case firstAirTime = "first_air_time"
            case overview
            case primaryLanguage = "primary_language"
            case status
            case tvdbID = "tvdb_id"
            case year, network, thumbnail
        }
    }
}
