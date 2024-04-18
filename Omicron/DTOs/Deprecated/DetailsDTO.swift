//
//  OverViewDetails.swift
//  Omicron
//
//  Created by Beni Kis on 12/03/2024.
//

import Foundation

struct DetailsDTO: Codable, Identifiable {
    var id: String
    let title: Title
    let ratings: Ratings
    let plotOutline: PlotOutline
    
    struct Title: Codable {
        let runningTimeInMinutes: Int
        let numberOfEpisodes: Int
        let seriesEndYear: Int?
        let seriesStartYear: Int
        let title: String
        let image: Image
        
        struct Image: Codable {
            let url: String
        }
    }
    
    struct Ratings: Codable {
        let rating: Double
        let ratingCount: Int
    }
    
    struct PlotOutline: Codable {
        let text: String
    }
}
