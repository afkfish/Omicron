//
//  Season.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation
import SwiftData


struct Season: Identifiable, Codable {
    var id: Int
    var episodes: [Episode]
    var episodeCount: Int {
        episodes.count
    }
    
    init(id: Int, episodes: [Episode]) {
        self.id = id
        self.episodes = episodes
    }
}

extension Season {
    init() {
        self.init(id: 0, episodes: [])
    }
}
