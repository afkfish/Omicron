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
    final var firstAirDate: String
    var overview: String?
    final var primaryLang: String
    final var status: String
    var network: String?
    var thumbnail: String?
    final var year: Int
    
    init(id: String, country: String, imageURL: String, name: String, firstAirDate: String, overview: String?, primaryLang: String, status: String, network: String? = nil, thumbnail: String? = nil, year: Int) {
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
            year: Int(NSString(string: data.year).intValue)
        )
    }
}
