//
//  SeasonModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class SeasonModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, seasonNumber, episodeCount, show, episodes, progresses
    }
    
    var id: String
    var seasonNumber: Int
    var episodeCount: Int
    @Relationship var show: ShowModel?
    @Relationship(inverse: \EpisodeModel.season) var episodes: [EpisodeModel] = []
    @Relationship(deleteRule: .cascade, inverse: \WatchProgressModel.season) var progresses: [WatchProgressModel] = []
    
    init(id: String, seasonNumber: Int, episodeCount: Int, show: ShowModel? = nil, episodes: [EpisodeModel] = []) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.episodeCount = episodeCount
        self.show = show
        self.episodes = episodes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        self.episodeCount = try container.decode(Int.self, forKey: .episodeCount)
        self.show = try container.decode(ShowModel.self, forKey: .show)
        self.episodes = try container.decode([EpisodeModel].self, forKey: .episodes)
        self.progresses = try container.decode([WatchProgressModel].self, forKey: .progresses)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.seasonNumber, forKey: .seasonNumber)
        try container.encode(self.episodeCount, forKey: .episodeCount)
        try container.encode(self.show, forKey: .show)
        try container.encode(self.episodes, forKey: .episodes)
        try container.encode(self.progresses, forKey: .progresses)
    }
}

// MARK: - Convenience Methods
extension SeasonModel {
    static func createEmptySeason(for show: ShowModel, withId id: String, number: Int) -> SeasonModel {
        SeasonModel(id: id, seasonNumber: number, episodeCount: 0, show: show)
    }
}
