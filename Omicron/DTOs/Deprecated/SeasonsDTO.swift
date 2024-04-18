//
//  SeasonsDTO.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation

struct SeasonsDTO: Codable {
    var data: DataClass
    
    // MARK: - DataClass
    struct DataClass: Codable {
        var title: Title
    }

    // MARK: - Title
    struct Title: Codable {
        var episodes: Episodes
    }

    // MARK: - Episodes
    struct Episodes: Codable {
        var displayableSeasons: DisplayableSeasons
        var edges: [Node]
    }

    // MARK: - DisplayableSeasons
    struct DisplayableSeasons: Codable {
        var total: Int
    }

    // MARK: - Node
    struct Node: Codable {
        var season: String
    }
}
