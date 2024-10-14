//
//  EpisodeModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class EpisodeModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, episodeNumber, title, overview, airDate, seasonNumber
    }
    
    var id: String
    var episodeNumber: Int
    var title: String
    var overview: String?
    var airDate: Date?
    var seasonNumber: Int?
    
    init(id: String, episodeNumber: Int, title: String, overview: String? = nil, airDate: Date? = nil, seasonNumber: Int? = nil) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.title = title
        self.overview = overview
        self.airDate = airDate
        self.seasonNumber = seasonNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required properties
        self.id = try container.decode(String.self, forKey: .id)
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.title = try container.decode(String.self, forKey: .title)
        
        // Optional properties
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.airDate = try container.decodeIfPresent(Date.self, forKey: .airDate)
        self.seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.episodeNumber, forKey: .episodeNumber)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.overview, forKey: .overview)
        try container.encode(self.airDate, forKey: .airDate)
        try container.encode(self.seasonNumber, forKey: .seasonNumber)
    }
}

// MARK: - Convenience Methods
extension EpisodeModel {
    static func toEpisodeList(from data: [ShowDTO.DataClass.Episode]) -> [EpisodeModel] {
        data.map({EpisodeModel(from: $0)})
    }
}

// MARK: - Converter
extension EpisodeModel {
    convenience init(from data: ShowDTO.DataClass.Episode) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.init(
            id: String(data.id),
            episodeNumber: data.number,
            title: data.name,
            overview: data.overview,
            airDate: dateFormatter.date(from: data.aired ?? "1970-01-01"),
            seasonNumber: data.seasonNumber
        )
    }
}
