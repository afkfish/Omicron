//
//  UserModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class UserModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, username, email, isOffline, library, ratings, progresses
   }
    
    var id: String
    var username: String
    var email: String
    var isOffline: Bool
    @Relationship(deleteRule: .cascade, inverse: \ShowModel.inLibraryOf) var library: [ShowModel] = []
    @Relationship(deleteRule: .cascade, inverse: \RatingModel.user) var ratings: [RatingModel] = []
    @Relationship(deleteRule: .cascade, inverse: \WatchProgressModel.user) var progresses: [WatchProgressModel] = []

    init(id: String, username: String, email: String, isOffline: Bool, libaray: [ShowModel] = [], ratings: [RatingModel] = [], progresses: [WatchProgressModel] = []) {
        self.id = id
        self.username = username
        self.email = email
        self.isOffline = isOffline
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.isOffline = try container.decode(Bool.self, forKey: .isOffline)
        self.library = try container.decode([ShowModel].self, forKey: .library)
        self.ratings = try container.decode([RatingModel].self, forKey: .ratings)
        self.progresses = try container.decode([WatchProgressModel].self, forKey: .progresses)
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
    }
}

// MARK: - Convenience Methods
extension UserModel {
    static func fetchOrCreate(withId id: String, in context: ModelContext) -> UserModel {
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.id == id })
        let results = (try? context.fetch(descriptor)) ?? []
        if let existingUser = results.first {
            return existingUser
        }
        let newUser = UserModel(id: id, username: "", email: "", isOffline: false)
        context.insert(newUser)
        return newUser
    }
    
    func fetchOrCreateProgress(withId showId: String, forSeason season: Int) -> WatchProgressModel? {
        if let progress = self.progresses.first(where: {$0.show?.id == showId && $0.season?.seasonNumber == season}) {
            return progress
        } else {
            let show = self.getShow(withId: showId)
            let season = show?.seasons.first(where: {$0.seasonNumber == season})
            
            guard show != nil && season != nil else { return nil }
            
            let progress = WatchProgressModel(user: self, show: show!, season: season!)
            self.progresses.append(progress)
            return progress
        }
    }
    
    func rateShow(show id: String, value: Int) {
        if let rating = self.ratings.first(where: { $0.show?.id == id }) {
                rating.value = value
        } else {
            let show = self.getShow(withId: id)
            
            guard show != nil else { return }
            
            let rating = RatingModel(value: value, user: self, show: show!)
            self.ratings.append(rating)
        }
    }
    
    private func getShow(withId id: String) -> ShowModel? {
        self.library.first(where: {$0.id == id})
    }
}
