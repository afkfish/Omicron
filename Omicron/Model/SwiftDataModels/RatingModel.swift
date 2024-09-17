//
//  RatingModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/09/2024.
//

import Foundation
import SwiftData

@Model
class RatingModel: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case value, user, show
    }
    
    var value: Int
    @Relationship var user: UserModel?
    @Relationship var show: ShowModel?
    
    init(value: Int, user: UserModel, show: ShowModel) {
        self.value = value
        self.user = user
        self.show = show
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
        self.user = try container.decode(UserModel.self, forKey: .user)
        self.show = try container.decode(ShowModel.self, forKey: .show)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.user, forKey: .user)
        try container.encode(self.show, forKey: .show)
    }
}
