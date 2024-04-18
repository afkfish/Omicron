//
//  EpisodesPerSeasonDTO.swift
//  Omicron
//
//  Created by Beni Kis on 20/03/2024.
//

import Foundation

struct EpisodesPerSeasonDTO: Codable {
    var data: DataClass
    
    // MARK: - DataClass
    struct DataClass: Codable {
        var title: Title?
    }

    // MARK: - Title
    struct Title: Codable {
        var id: String?
        var episodes: TitleEpisodes?
    }

    // MARK: - TitleEpisodes
    struct TitleEpisodes: Codable {
        var episodes: EpisodesEpisodes?
    }

    // MARK: - EpisodesEpisodes
    struct EpisodesEpisodes: Codable {
        var edges: [Edge]?
        var total: Int?
    }

    // MARK: - Edge
    struct Edge: Codable {
        var node: Node?
        var position: Int?
    }

    // MARK: - Node
    struct Node: Codable {
        var id: String?
        var plot: Plot?
    }

    // MARK: - Plot
    struct Plot: Codable {
        var id: String?
        var plotText: PlotText?
    }

    // MARK: - PlotText
    struct PlotText: Codable {
        var plainText: String?
    }
}

