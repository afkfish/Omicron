//
//  Episode.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation
import SwiftData

struct Episode: Identifiable, Codable {
    var id: Int
    var name: String
    var aired: String
    var runtime: Int
    var overview: String?
    var episodeNumber: Int
    var seasonNumber: Int
    var year: Int?
    
    init(id: Int, name: String, aired: String, runtime: Int, overview: String? = nil, episodeNumber: Int, seasonNumber: Int, year: Int? = nil) {
        self.id = id
        self.name = name
        self.aired = aired
        self.runtime = runtime
        self.overview = overview
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.year = year
    }
}

extension Episode {
    init() {
        self.init(id: 0, name: "", aired: "true", runtime: 10, overview: "", episodeNumber: 0, seasonNumber: 0, year: 0)
    }
    
    init(from data: ShowDTO.DataClass.Episode) {
        self.init()
        self.id = data.id
        self.name = data.name
        self.aired = data.aired ?? ""
        self.runtime = data.runtime ?? 0
        self.overview = data.overview
        self.episodeNumber = data.number
        self.seasonNumber = data.seasonNumber
        self.year = Int(data.year ?? "")
    }
}
