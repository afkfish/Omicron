//
//  SearchDetailViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import Foundation
import Combine
import SwiftData

/// ViewModel for the `SearchDetailsView`, this can download a show's full information,
/// add it to the `ModelContext` and add a show to the user's library.
class SearchDetailViewModel: ObservableObject {
    private var apiController: APIController!
    private var accountManager: AccountManager!
    
    @Published var finished: Bool = false
    @Published var show: ShowModel?
    
    func setup(apiController: APIController, accountManager: AccountManager) {
        self.apiController = apiController
        self.accountManager = accountManager
    }
    
    func getShow(id: String) {
        Task {
            await apiController.getShow(id: Int(id)!, page: 0)
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
    
    func saveShow(modelContainer: ModelContainer) {
        guard let show else { return }
        let libraryManager = LibraryManager(modelContainer: modelContainer)
        Task {
            await libraryManager.addToModelContext(show)
            addToUserLibrary(show: show)
        }
    }
    
    func addToUserLibrary(show: ShowModel) {
        if let account = accountManager.currentAccount {
            if (!account.library.contains { $0.id == show.id }) {
                account.library.append(show)
            }
        }
    }
}
