//
//  WatchProgressModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class WatchProgressModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case progress, user, season
    }
    
    var progress: Int
    @Relationship var user: UserModel?
    @Relationship var show: ShowModel?
    @Relationship var season: SeasonModel?
    
    init(progress: Int = 0, user: UserModel, show: ShowModel, season: SeasonModel) {
        self.progress = progress
        self.user = user
        self.show = show
        self.season = season
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.progress = try container.decode(Int.self, forKey: .progress)
        self.user = try container.decode(UserModel.self, forKey: .user)
        self.season = try container.decode(SeasonModel.self, forKey: .season)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.progress, forKey: .progress)
        try container.encode(self.user, forKey: .user)
        try container.encode(self.season, forKey: .season)
    }
}
