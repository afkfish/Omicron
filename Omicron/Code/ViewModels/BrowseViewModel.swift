//
//  BrowseViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 29/04/2024.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

/// ViewModel for the `BrowseView`, this can search with a given `APIController`
/// and uses `Combine` for it and can insert the search results into the `ModelContext`.
class BrowseViewModel: ObservableObject {
    private var apiController: APIController!
    private var accountManager: AccountManager!
    
    @Published var isFinished: Bool = false
    @Published private(set) var searchResults: Set<ShowOverviewModel> = []
    
    func setup(apiController: APIController, accountManager: AccountManager) {
        self.apiController = apiController
        self.accountManager = accountManager
    }
    
    func search(query: String) {
        guard !query.isEmpty else { return }
        Task { [weak self] in
            guard let self else { return }
            await self.apiController.search(for: query)
                .map {res -> Bool in
                    guard res.data != nil else { return false }
                    
                    self.searchResults = Set(res.data!.map {
                        ShowOverviewModel(from: $0)
                    })
                    return true
                }
                .assign(to: &$isFinished)
        }
    }
}
