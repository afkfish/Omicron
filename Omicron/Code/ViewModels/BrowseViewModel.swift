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


class BrowseViewModel: ObservableObject {
    @Published var isFinished: Bool = false
    @Published private(set) var searchResults: Set<ShowOverviewModel> = []
    
    func search(_ apiController: APIController, query: String) async {
        guard !query.isEmpty else { return }
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
