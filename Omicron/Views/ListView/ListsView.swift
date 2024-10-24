//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.defaultAPIController) private var apiController
    
    @ObservedObject private var vm = ListViewModel()
    
    @State private var searchPhrase: String = ""
            
    var body: some View {
        NavigationStack {
            ZStack {
                theme.selected.primary
                    .ignoresSafeArea(.all)
                List {
                    ForEach(searchResults.sorted(by: <)) {show in
                        NavigationLink {
                            DetailsView(show: show)
                        } label: {
                            ListViewItemLabel(show: show)
                        }
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchPhrase, prompt: "Title of the show")
                .refreshable(action: {
                    do {
                        try await accountManager.refreshLibrary(apiController, modelContext.container)
                    } catch {
                        print(error)
                    }
                })
                .navigationTitle("Library")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .onAppear {
                vm.setUp(accountManager: accountManager)
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
        if searchPhrase.isEmpty {
            return library
        } else {
            return library.filter { $0.title.lowercased().contains(searchPhrase.lowercased()) }
        }
    }
    
    private func delete(offsets: IndexSet) {
        vm.deleteItems(offsets: offsets, searchResults: searchResults)
    }
}

#Preview {
    ListsView()
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
