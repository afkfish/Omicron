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
    private var searchList: Set<String> = []
    @Published var searchText: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var modelContext: ModelContext?
    
    func start(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadData()
    }
    
    func loadData() {
        do {
            searchList = Set(try modelContext!.fetch(FetchDescriptor<ShowOverviewModel>()).map {$0.id})
        } catch {
            print(error)
        }
    }
    
    func search(_ apiController: APIController) async {
        await apiController.search(for: searchText.isEmpty ? "A" : searchText)
            .map {(res) -> Set<ShowOverviewModel> in
                guard res.data != nil else { return [] }
                return Set(res.data!.map {
                    ShowOverviewModel(from: $0)
                })
            }
            .sink { [weak self] newItems in
                self?.appendToModel(newItems)
            }
            .store(in: &subscriptions)
    }
    
    func appendToModel(_ newItems: Set<ShowOverviewModel>) {
        let itemsToAdd = newItems.filter { !searchList.contains($0.id) }

        for item in itemsToAdd {
            searchList.insert(item.id)
            modelContext?.insert(item)
        }
    }
}
