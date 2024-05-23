//
//  ListsViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 16/05/2024.
//

import Foundation
import SwiftData
import SwiftUI

class ListsViewModel: ObservableObject {
    private var shows: [Show] = []
    
    private var modelContext: ModelContext?
    
    func start(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadData()
    }
    
    func loadData() {
        do {
            shows = try modelContext!.fetch(FetchDescriptor<Show>())
        } catch {
            print(error)
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext!.delete(shows[index])
                Task {
                    try await FireStore.shared.removeFromList(value: String(shows[index].id))
                }
            }
        }
    }
    
    func addShow(show: Show) {
        withAnimation {
            modelContext!.insert(show)
        }
    }
}
