//
//  ShowDTO.swift
//  Omicron
//
//  Created by Beni Kis on 28/03/2024.
//

import Foundation

struct ShowDTO: Codable {
    var data: DataClass?
    var links: Links?
    
    struct DataClass: Codable {
        let series: Series
        let episodes: [Episode]
        
        struct Series: Codable {
            let id: Int
            let name: String
            let image: String
            let firstAired, lastAired, nextAired: String
            let score: Int
            let status: Status
            let originalLanguage: String
            let lastUpdated: String
            let averageRuntime: Int
            let overview, year: String
            
            struct Status: Codable {
                let name: String
            }
        }
        
        struct Episode: Codable {
            let id: Int
            let seriesId: Int
            let name: String
            let aired: String?
            let runtime: Int?
            let overview: String?
            let image: String?
            let isMovie: Int
            let number, seasonNumber: Int
            let lastUpdated: String
            let year: String?
        }
    }
    
    struct Links: Codable {
        let totalItems, pageSize: Int?
        
        enum CodingKeys: String, CodingKey {
            case totalItems = "total_items"
            case pageSize = "page_size"
        }
    }
}
