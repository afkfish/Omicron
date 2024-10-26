//
//  UserModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class UserModel: Identifiable, Codable, ObservableObject {
    enum CodingKeys: CodingKey {
        case id, username, email, isOffline, library, ratings, progresses, version
   }
    
    var id: String
    var username: String
    var email: String
    var isOffline: Bool
    @Relationship(deleteRule: .cascade) var library: [ShowModel] = []
    var ratings: [String: Int] = [:]
    var progresses: [String: [Int: Int]] = [:]
    var version: Int = 0

    init(id: String, username: String, email: String, isOffline: Bool, library: [ShowModel] = [], ratings: [String: Int] = [:], progresses: [String: [Int: Int]] = [:]) {
        self.id = id
        self.username = username
        self.email = email
        self.isOffline = isOffline
        self.library = library
        self.ratings = ratings
        self.progresses = progresses
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required properties
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.isOffline = try container.decode(Bool.self, forKey: .isOffline)
        self.library = try container.decode([ShowModel].self, forKey: .library)
        self.ratings = try container.decode([String: Int].self, forKey: .ratings)
        self.progresses = try container.decode([String: [Int: Int]].self, forKey: .progresses)
        self.version = try container.decode(Int.self, forKey: .version)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.isOffline, forKey: .isOffline)
        try container.encode(self.library, forKey: .library)
        try container.encode(self.ratings, forKey: .ratings)
        try container.encode(self.progresses, forKey: .progresses)
        try container.encode(self.version, forKey: .version)
    }
}

// MARK: - Convenience Methods
extension UserModel {
    func fetchOrCreateProgress(withId id: String, forSeason season: Int) -> Int {
        if let showProgress = self.progresses[id] {
            if let progress = showProgress[season] {
                return progress
            } else {
                self.progresses[id]![season] = 0
            }
        } else {
            self.progresses[id] = [:]
            self.progresses[id]![season] = 0
        }
        return 0
    }
    
    func getShowProgress(show id: String, seasonNumber: Int) -> Int {
        self.progresses[id]?[seasonNumber] ?? 0
    }
    
    private func getShow(withId id: String) -> ShowModel? {
        self.library.first(where: {$0.id == id})
    }
}
