//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData
import SwiftSoup
import Combine

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]
    
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
                            Text(show.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .listRowBackground(Color.offWhite)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Title of the show")
                .navigationTitle("My list")
                .toolbarBackground(Color.offWhite, for: .navigationBar)
            }
        }
    }
    
    var searchResults: [Show] {
        if searchText.isEmpty {
            return shows
        } else {
            return shows.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(shows[index])
            }
        }
    }
    
    private func addShow(show: Show) {
        withAnimation {
            modelContext.insert(show)
        }
    }
}

#Preview {
    ListsView()
        .modelContainer(for: Show.self, inMemory: true)
}
