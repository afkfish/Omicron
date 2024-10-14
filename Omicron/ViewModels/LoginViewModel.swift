//
//  LoginViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/05/2024.
//

import Foundation
import SwiftUI
import SwiftData

class LoginViewModel: ObservableObject {
    private var shows: [String] = []
    var apiController: APIController?
    
    func start(apiController: APIController) {
        self.apiController = apiController
    }
    
    @Published private var finished = false
    @Published var finishedAll = false
    @Published var showResults: [ShowModel] = []
    
    func getShows(ids: [String]) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                for id in ids {
                    group.addTask {
                        await self.apiController!.getSeries(id: Int(id)!, page: 0)
                            .map { dto in
                                guard let show = dto.data else { return false }
                                let temp = ShowModel(from: show)
                                let seasons = Set(show.episodes.map({($0.seasonNumber)}))
                                let episodes = EpisodeModel.toEpisodeList(from: show.episodes)
                                for seasonNumber in seasons {
                                    let season = SeasonModel.createEmptySeason(for: temp, withId: "\(temp.id)\(seasonNumber)", number: seasonNumber)
                                    temp.seasons.append(season)
                                    season.episodes.append(contentsOf: episodes.filter  {$0.seasonNumber == seasonNumber})
                                    season.episodeCount = season.episodes.count
                                }
                                self.showResults.append(temp)
                                return true
                            }
                            .assign(to: &self.$finished)
                    }
                }
            }
            finishedAll = true
        }
    }
}
