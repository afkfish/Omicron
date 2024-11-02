//
//  ShowModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

/// SwiftData model for a show
@Model
class ShowModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, title, overview, posterPath, firstAirDate, lastAirDate, status, episodeLength, lang, year, link, seasons
    }
    
    var id: String
    var title: String
    var overview: String?
    var posterPath: String?
    var firstAirDate: String?
    var lastAirDate: String?
    var status: String?
    var episodeLength: Int?
    var lang: String?
    var year: String?
    var link: String?
    /// One to many relationship, one directional
    @Relationship var seasons: [SeasonModel] = []

    init(id: String, title: String, overview: String? = nil, posterPath: String? = nil, firstAirDate: String? = nil, lastAirDate: String? = nil, status: String? = nil, episodeLength: Int? = 0, lang: String? = "engm", year: String? = "2000", link: String? = nil, seasons: [SeasonModel] = []) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.lastAirDate = lastAirDate
        self.status = status
        self.episodeLength = episodeLength
        self.lang = lang
        self.year = year
        self.link = link
        self.seasons = seasons
    }
    
    // MARK: - Functions for Codable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required properties
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        // Optional properties
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.lastAirDate = try container.decodeIfPresent(String.self, forKey: .lastAirDate)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.episodeLength = try container.decodeIfPresent(Int.self, forKey: .episodeLength)
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        self.year = try container.decodeIfPresent(String.self, forKey: .year)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.seasons = try container.decode([SeasonModel].self, forKey: .seasons)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.overview, forKey: .overview)
        try container.encode(self.posterPath, forKey: .posterPath)
        try container.encode(self.firstAirDate, forKey: .firstAirDate)
        try container.encode(self.lastAirDate, forKey: .lastAirDate)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.episodeLength, forKey: .episodeLength)
        try container.encode(self.lang, forKey: .lang)
        try container.encode(self.year, forKey: .year)
        try container.encode(self.link, forKey: .link)
        try container.encode(self.seasons, forKey: .seasons)
    }
}

// MARK: - Convenience Methods
extension ShowModel {
    static func fetch(withId id: String, in context: ModelContext) -> ShowModel? {
        let descriptor = FetchDescriptor<ShowModel>(predicate: #Predicate { $0.id == id })
        let results = (try? context.fetch(descriptor)) ?? []
        if let existingShow = results.first {
            return existingShow
        }
        return nil
    }
    
    func getSeason(withNumber number: Int) -> SeasonModel? {
        self.seasons.first(where: {$0.seasonNumber == number})
    }
}

// MARK: - Sample Data
extension ShowModel {
    static var sample: ShowModel {
        ShowModel(
            id: "0",
            title: "Adventure Time",
            overview: "overview",
            posterPath: "https://m.media-amazon.com/images/M/MV5BMGFkNGY4NGMtZjY0NC00YTI0LThiZjMtMjBmZGMzOGU3YTdmXkEyXkFqcGdeQXVyMTM0NTUzNDIy._V1_.jpg",
            firstAirDate: "2000-01-01",
            lastAirDate: "2024-09-17",
            status: "Ended",
            episodeLength: 21,
            lang: "engm",
            year: "2010",
            link: "https://www.imdb.com/title/tt1305826/"
        )
    }
}

// MARK: - Converter
extension ShowModel {
    /// Convert from a ShowDTO
    convenience init(from data: ShowDTO.DataClass) {
        self.init(
            id: String(data.series.id),
            title: data.series.name,
            overview: data.series.overview,
            posterPath: data.series.image,
            firstAirDate: data.series.firstAired,
            lastAirDate: data.series.lastAired,
            status: data.series.status.name,
            episodeLength: data.series.averageRuntime,
            lang: data.series.originalLanguage,
            year: data.series.year
        )
    }
}

// MARK: - Comparation
extension ShowModel: Comparable {
    static func < (lhs: ShowModel, rhs: ShowModel) -> Bool {
        if lhs.title != rhs.title {
            lhs.title < rhs.title
        } else {
            lhs.id < rhs.id
        }
    }
}
