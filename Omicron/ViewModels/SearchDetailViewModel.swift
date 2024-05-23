//
//  SearchDetailViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import Foundation
import Combine


class SearchDetailViewModel: ObservableObject {
    private var shows: [Int] = []
    
    @Published var show: Show?
    
    func addShow(id: Int, _ apiController: APIController) async {
        // Check if the show with the given ID is already present
        guard !shows.contains(id) else {
            return // Show already exists, no need to fetch again
        }
        shows.append(id)
        addToList(name: "favourites", value: String(id))
        
        await apiController.getSeries(id: id, page: 0)
            .map { dto in
                return Show(from: dto)
            }
            .assign(to: &$show)
        
//        // Define a function to fetch series data recursively
//        func fetchSeriesRecursively(show: Show, pageNum: Int = 0) async {
//            
//            
//            
//            /*{ data, leftover in
//             let fetchedShow = Show(from: data)
//             var baseShow = show
//             if pageNum == 0 {
//             baseShow = fetchedShow
//             }
//             print(leftover)
//             
//             // Aggregate episodes from the fetched show to the existing show object
//             fetchedShow.seasons.forEach { (key, value) in
//             print(key)
//             if let existingSeason = baseShow.seasons[key] {
//             var combinedEpisodes = existingSeason.episodes
//             combinedEpisodes.append(contentsOf: value.episodes)
//             baseShow.seasons[key] = Season(id: existingSeason.id, episodes: combinedEpisodes)
//             } else {
//             baseShow.seasons[key] = value
//             }
//             }
//             
//             // If there are leftover items, fetch the next page recursively
//             if leftover > 0 {
//             fetchSeriesRecursively(show: baseShow, pageNum: pageNum + 1)
//             } else {
//             // No leftover items, all data fetched, insert the aggregated show into the model context
//             withAnimation {
//             modelContext.insert(baseShow)
//             addedSuccesfuly = true
//             }
//             }*/
//        }
//        
//        // Start fetching series data recursively with an empty show object
//        var emptyShow = Show(id: id) // Assuming you have an initializer for Show with just ID
//        await fetchSeriesRecursively(show: emptyShow)
    }
    
    func addToList(name: String, value: String) {
        Task {
        do {
            try await FireStore.shared.addToList(name: name, value: value)
        } catch {
            print(error)
        }
        }
    }
}
