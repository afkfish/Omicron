//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData
import SwiftSoup

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]
    
    @State private var showSafari = false
    @State private var scrape_error: Bool = false
    @State private var searchText = ""
    
    static let baseURL = "https://www.imdb.com/search/title/?title_type=tv_series"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) {show in
                    NavigationLink {
                        ShowDetailsView(show: Binding.constant(show))
                    } label: {
                        Text(show.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: $searchText, prompt: "Title of the show")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSafari = true
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                    .popover(isPresented: $showSafari) {
                        PopOverWebView(showSafari: $showSafari, scrapeError: $scrape_error)
                    }
                }
            }
        }
        .alert("Error in parsing the show!", isPresented: $scrape_error) {
            Button("OK", role: .cancel) {}
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
    
    func addDebug() {
        modelContext.insert(Show.exaple)
    }
}

#Preview {
    ListsView()
        .modelContainer(for: Show.self, inMemory: true)
}
