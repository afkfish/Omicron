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
    final var id: Int
    final var name: String
    final var image: String
    final var firstAired: String
    var lastAired: String
    var nextAired: String
    var score: Int
    var status: String
    final var originalLanguage: String
    final var runningTimeInMinutes: Int
    final var desc: String
    final var year: String
    
//    final var rating: String
    var seasons: [Int:Season] = [:]
    var seasonCount: Int { seasons.count }
    var episodes: Int
    
    var link: URL?
    
    init(id: Int, name: String, image: String, firstAired: String, lastAired: String, nextAired: String, score: Int, status: String, originalLanguage: String, runningTimeInMinutes: Int, desc: String, year: String, seasons: [Int:Season], episodes: Int, link: URL? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.firstAired = firstAired
        self.lastAired = lastAired
        self.nextAired = nextAired
        self.score = score
        self.status = status
        self.originalLanguage = originalLanguage
        self.runningTimeInMinutes = runningTimeInMinutes
        self.desc = desc
        self.year = year
        self.seasons = seasons
        self.episodes = episodes
        self.link = link
    }
}

extension Show {
    static var exaple: Show {
        let show = Show(id: 0, name: "Adventure Time", image: "https://m.media-amazon.com/images/M/MV5BMGFkNGY4NGMtZjY0NC00YTI0LThiZjMtMjBmZGMzOGU3YTdmXkEyXkFqcGdeQXVyMTM0NTUzNDIy._V1_.jpg", firstAired: "2010", lastAired: "2018", nextAired: "", score: 10, status: "ended", originalLanguage: "engm", runningTimeInMinutes: 11, desc: "asd", year: "2010", seasons: [:], episodes: 500, link: URL(string: "https://www.imdb.com/title/tt1305826/"))
        return show
    }
}

extension Show {
    convenience init(id: Int) {
        self.init(id: id, name: "", image: "", firstAired: "", lastAired: "", nextAired: "", score: 0, status: "", originalLanguage: "", runningTimeInMinutes: 0, desc: "", year: "", seasons: [:], episodes: 0, link: URL(string: ""))
    }
    
    convenience init(from data: ShowDTO) {
        let dt = data.data!
        self.init(id: dt.series.id)
        
        self.name = dt.series.name
        self.runningTimeInMinutes = dt.series.averageRuntime
        self.episodes = data.links!.totalItems!
        self.firstAired = dt.series.firstAired
        self.lastAired = dt.series.lastAired
        self.nextAired = dt.series.nextAired
        self.status = dt.series.status.name
        self.originalLanguage = dt.series.originalLanguage
        self.year = dt.series.firstAired
        self.score = dt.series.score
        self.desc = dt.series.overview
        self.link = URL(string: "")
        self.image = dt.series.image
        
        let episodes = dt.episodes.map {episode in
            Episode(from: episode)
        }
        
        var seasonMap: Dictionary<Int, Season> = [:]
        
        episodes.forEach {episode in
            if (seasonMap.keys.contains(episode.seasonNumber)) {
                seasonMap[episode.seasonNumber]?.episodes.append(episode)
            } else {
                seasonMap[episode.seasonNumber] = Season(id: dt.series.id+episode.seasonNumber, episodes: [episode])
            }
        }
        self.seasons = seasonMap
    }
}
