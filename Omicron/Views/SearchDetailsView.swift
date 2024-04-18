//
//  SearchItemDetails.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI
import SwiftData

struct SearchDetailsView: View {
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]

    @Binding var show: ShowInfo
    
    @State private var addedSuccesfuly = false

    var body: some View {
        ZStack {
            Color.offWhite
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    AsyncImage(url: URL(string: show.imageURL)!) {image in
                        image.resizable()
                    } placeholder: {
                        Text("Loading...")
                    }
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text("Status: \(show.status)")
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                .frame(height: 200)
                HStack {
                    Text(String(show.year))
                    Spacer()
                    Text("Language: \(show.primaryLang)m")
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom)
                ScrollView {
                    Text(show.overview ?? "")
                        .padding(.horizontal)
                }
                Spacer()
                Button("Add show to list") {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    addShow(id: Int(show.id)!)
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                .padding()
            }
            .navigationTitle(show.name)
            .alert("Show added to list", isPresented: $addedSuccesfuly) {}
        }
    }
    
    private func addShow(id: Int) {
        // Check if the show with the given ID is already present
        guard !shows.contains(where: { $0.id == id }) else {
            return // Show already exists, no need to fetch again
        }
        
        // Define a function to fetch series data recursively
        func fetchSeriesRecursively(show: Show, pageNum: Int = 0) {
            apiController.getSeries(id: id, page: pageNum) { data, leftover in
                let fetchedShow = Show(from: data)
                var baseShow = show
                if pageNum == 0 {
                    baseShow = fetchedShow
                }
                print(leftover)
                
                // Aggregate episodes from the fetched show to the existing show object
                fetchedShow.seasons.forEach { (key, value) in
                    print(key)
                    if let existingSeason = baseShow.seasons[key] {
                        var combinedEpisodes = existingSeason.episodes
                        combinedEpisodes.append(contentsOf: value.episodes)
                        baseShow.seasons[key] = Season(id: existingSeason.id, episodes: combinedEpisodes)
                    } else {
                        baseShow.seasons[key] = value
                    }
                }
                
                // If there are leftover items, fetch the next page recursively
                if leftover > 0 {
                    fetchSeriesRecursively(show: baseShow, pageNum: pageNum + 1)
                } else {
                    // No leftover items, all data fetched, insert the aggregated show into the model context
                    withAnimation {
                        modelContext.insert(baseShow)
                        addedSuccesfuly = true
                    }
                }
            }
        }

        // Start fetching series data recursively with an empty show object
        var emptyShow = Show(id: id) // Assuming you have an initializer for Show with just ID
        fetchSeriesRecursively(show: emptyShow)
        
        
        
        
        
//        if (!shows.contains {$0.id == id}) {
//            var pageNum = 0
//            apiController.getSeries(id: id, page: pageNum) {data, leftover in
//                let sh = Show(from: data)
//                print(leftover)
//                if (leftover > 0) {
//                    pageNum += 1
//                    apiController.getSeries(id: id, page: pageNum) {data2, leftover in
//                        addedSuccesfuly = true
//                        let sho = Show(from: data2)
//                        sho.seasons.forEach {
//                            if sh.seasons[$0.key] != nil {
//                                sh.seasons[$0.key]!.episodes.append(contentsOf: $0.value.episodes)
//                            } else {
//                                sh.seasons[$0.key] = $0.value
//                            }
//                        }
//                        withAnimation {
//                            modelContext.insert(sh)
//                        }
//                    }
//                } else {
//                    addedSuccesfuly = true
//                    withAnimation {
//                        modelContext.insert(sh)
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    SearchDetailsView(show: Binding.constant(ShowInfo.dummy))
        .modelContainer(for: Show.self, inMemory: true)
}
