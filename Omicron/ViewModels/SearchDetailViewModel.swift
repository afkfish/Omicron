//
//  SearchDetailViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import Foundation
import Combine


class SearchDetailViewModel: ObservableObject {
    private var apiController: APIController?
    
    @Published var finished: Bool = false
    @Published var show: ShowModel?
    
    func setup(apiController: APIController) {
        self.apiController = apiController
    }
    
    func getShow(id: String) async {
        await apiController!.getSeries(id: Int(id)!, page: 0)
            .map { dto in
                guard let show = dto.data else { return false }
                self.show = ShowModel(from: show)
                let seasons = Set(show.episodes.map({($0.seasonNumber)}))
                let episodes = EpisodeModel.toEpisodeList(from: show.episodes)
                for seasonNumber in seasons {
                    let season = SeasonModel.createEmptySeason(for: self.show!, withId: "\(self.show!.id)\(seasonNumber)", number: seasonNumber)
                    self.show!.seasons.append(season)
                    season.episodes.append(contentsOf: episodes.filter  {$0.seasonNumber == seasonNumber})
                    season.episodeCount = season.episodes.count
                }
                return true
            }
            .assign(to: &$finished)
    }
}
