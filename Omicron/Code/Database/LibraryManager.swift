//
//  LibraryManager.swift
//  Omicron
//
//  Created by Beni Kis on 2024. 11. 02..
//

import Foundation
import SwiftData

actor LibraryManager {
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    func fetchOfflineShows(ids: [String]) throws -> [ShowModel] {
        try modelContext.fetch(FetchDescriptor<ShowModel>(predicate: #Predicate { ids.contains($0.id) }))
    }

    func addToModelContext(_ show: (any PersistentModel)) {
        modelContext.insert(show)
    }
}
