//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData
import Combine

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]
    @ObservedObject private var vm = ListsViewModel()
    
    @State private var searchText = ""
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color.offWhite
                    .ignoresSafeArea(.all)
                List {
                    ForEach(searchResults) {show in
                        NavigationLink {
                            DetailsView(show: Binding.constant(show))
                        } label: {
                            VStack {
                                HStack {
                                    Text(show.name)
                                    Spacer()
                                    Text(show.score == 0 ? "-" : String(show.score))
                                }
                                HStack {
                                    ProgressView(value: Float(show.progress.map {$0.value}.reduce(0, +)), total: Float(show.episodes))
                                        .tint(.green)
                                }
                            }
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                    .listRowBackground(Color.offWhite)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Title of the show")
                .navigationTitle("Saved")
                .toolbarBackground(Color.offWhite, for: .navigationBar)
            }
            .onAppear {
                vm.start(modelContext: modelContext)
            }
        }
    }
    
    var userShows: [Show] {
        if AuthStore().data.authenticated {
            return shows.filter {show in
                FireStore.shared.user!.lists["favourites"]!.contains(String(show.id))
            }
        } else {
            return shows
        }
    }
    
    var searchResults: [Show] {
        if searchText.isEmpty {
            return userShows
        } else {
            return userShows.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ListsView()
        .modelContainer(for: Show.self, inMemory: true)
}
