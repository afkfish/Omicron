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
    @Published var isFinished: Bool = false
    @Published private(set) var searchResults: Set<ShowOverviewModel> = []
    
    func search(_ apiController: APIController, query: String) {
        guard !query.isEmpty else { return }
        Task {
            await apiController.search(for: query)
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
    
    func appendResults(overviewList: [ShowOverviewModel], modelContainer: ModelContainer) {
        let libManager = LibraryManager(modelContainer: modelContainer)
        searchResults.forEach { result in
            if (!overviewList.contains { $0.id == result.id }) {
                Task {
                    await libManager.addToModelContext(result)
                }
            }
        }
    }
}
