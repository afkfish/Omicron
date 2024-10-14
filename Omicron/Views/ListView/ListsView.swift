//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData

class ListofShows: ObservableObject {
    @Published var shows: [ShowModel]
    
    init(shows: [ShowModel]) {
        self.shows = shows
    }
}

struct ListsView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
        
    var body: some View {
        NavigationStack {
            ZStack {
                theme.selected.primary
                    .ignoresSafeArea(.all)
                List {
                    ForEach(searchResults) {show in
                        NavigationLink {
                            DetailsView(show: show)
                        } label: {
                            ListViewItemLabel(show: show)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Title of the show")
                .navigationTitle("Library")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
        }
    }
    
    var library: [ShowModel] {
        if let library = accountManager.currentAccount?.library {
            library
        } else {
            []
        }
    }
    
    var searchResults: [ShowModel] {
        if searchText.isEmpty {
            return library
        } else {
            return library.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        if searchText.isEmpty {
            accountManager.currentAccount?.library.remove(atOffsets: offsets)
        } else {
            let itemsToDelete = searchResults.enumerated().filter{ offsets.contains($0.offset) }.map {$0.element.id}
            accountManager.currentAccount?.library.removeAll(where: { itemsToDelete.contains($0.id) })
        }
        
    }
}

#Preview {
    ListsView()
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
