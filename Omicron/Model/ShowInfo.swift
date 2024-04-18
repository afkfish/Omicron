//
//  BaseDetail.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation
import SwiftData

@Model
final class ShowInfo: Identifiable {
    final var id: String
    final var country: String
    var imageURL: String
    final var name: String
    var firstAirDate: String?
    var overview: String?
    final var primaryLang: String
    final var status: String
    var network: String?
    var thumbnail: String?
    final var year: Int
    
    init(id: String, country: String, imageURL: String, name: String, firstAirDate: String?, overview: String?, primaryLang: String, status: String, network: String? = nil, thumbnail: String? = nil, year: Int) {
        self.id = id
        self.country = country
        self.imageURL = imageURL
        self.name = name
        self.firstAirDate = firstAirDate
        self.overview = overview
        self.primaryLang = primaryLang
        self.status = status
        self.network = network
        self.thumbnail = thumbnail
        self.year = year
    }
}

extension ShowInfo {
    convenience init(from data: SearchDTO.SearchShow) {
        self.init(
            id: data.tvdbID,
            country: data.country,
            imageURL: data.imageURL,
            name: data.name,
            firstAirDate: data.firstAirTime,
            overview: data.overview,
            primaryLang: data.primaryLanguage,
            status: data.status,
            year: Int(NSString(string: data.year ?? "0").intValue)
        )
    }
}

extension ShowInfo {
    static var dummy: ShowInfo {
        let data = Data("{\"objectID\": \"series-73762\",\"aliases\": [\"Grey's Anatomy - Die jungen Ärzte\",\"Dre Grey, leçons d'anatomie\"],\"country\": \"usa\",\"id\": \"series-73762\",\"image_url\": \"https://artworks.thetvdb.com/banners/posters/73762-25.jpg\",\"name\": \"Grey's Anatomy\",\"first_air_time\": \"2005-03-27\",\"overview\": \"A drama centered on the personal and professional lives of five surgical interns and their supervisors.\",\"primary_language\": \"eng\",\"primary_type\": \"series\",\"status\": \"Continuing\",\"type\": \"series\",\"tvdb_id\": \"73762\",\"year\": \"2005\",\"slug\": \"greys-anatomy\",\"network\": \"ABC (US)\",\"remote_ids\": [    {        \"id\": \"tt0413573\",        \"type\": 2,        \"sourceName\": \"IMDB\"    }],\"thumbnail\": \"https://artworks.thetvdb.com/banners/posters/73762-25_t.jpg\"}".utf8)
        let asd = try? JSONDecoder().decode(SearchDTO.SearchShow.self, from: data)
        return ShowInfo(from: asd!)
    }
}
