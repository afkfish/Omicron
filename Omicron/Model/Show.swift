//
//  Show.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import Foundation
import SwiftData

@Model
final class Show: Identifiable {
    final var id: String
    final var name: String
    final var airDate: String
    var rating: String = ""
    var score: Double
    var seasons: Int = 1
    var episodes: Int
    final var episodeLength: String
    final var desc: String
    final var image: String
    final var link: URL
    
    init(id: String, name: String, airDate:String, score: Double, episodes: Int, episodeLength: String, desc: String, image: String, link: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.score = score
        self.episodes = episodes
        self.episodeLength = episodeLength
        self.desc = desc
        self.image = image
        self.link = URL(string: link)!
    }
}

extension Show {
    static var exaple: Show {
        Show(id: "0", name: "Adventure Time", airDate: "2010-2018", score: 10, episodes: 100, episodeLength: "22m", desc: "asd", image: "https://m.media-amazon.com/images/M/MV5BMGFkNGY4NGMtZjY0NC00YTI0LThiZjMtMjBmZGMzOGU3YTdmXkEyXkFqcGdeQXVyMTM0NTUzNDIy._V1_.jpg", link: "https://www.imdb.com/title/tt1305826/")
    }
}
