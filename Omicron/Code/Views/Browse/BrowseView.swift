//
//  BrowseView.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import SwiftUI
import SwiftData

struct BrowseView: View {
    @EnvironmentObject private var theme: ThemeManager
    @Environment(\.modelContext) private var modelcontext
    @Environment(\.defaultAPIController) private var apiController
    @Query(sort: \ShowOverviewModel.name, order: .forward) private var overviewList: [ShowOverviewModel]
    @StateObject private var vm = BrowseViewModel()
    
    @State private var searchPhrase: String = ""
    
    var filteredSearchItems: [ShowOverviewModel] {
        if (searchPhrase.isEmpty) {
            overviewList
        } else {
            overviewList.filter { $0.name.lowercased().contains(searchPhrase.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if (filteredSearchItems.isEmpty) {
                    Text("Search to see more!")
                }
                List {
                    ForEach(filteredSearchItems) {item in
                        NavigationLink {
                            SearchDetailsView(show: item)
                        } label: {
                            SearchRowView(show: item)
                        }
                        .padding()
                        .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 20)))
                        .padding(.vertical, 12)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchPhrase, prompt: "Search for a show")
                .onChange(of: searchPhrase) {
                    if (filteredSearchItems.count < 3) {
                        Task { await search() }
                    }
                }
                .onChange(of: vm.isFinished) {
                    if (vm.isFinished) {
                        appendResults(results: vm.searchResults)
                        vm.isFinished = false
                    }
                }
                .navigationTitle("Browse")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .background(theme.selected.primary)
        }
    }
    
    private func search() async {
        await vm.search(apiController, query: searchPhrase)
    }
    
    private func appendResults(results: Set<ShowOverviewModel>) {
        results.forEach { result in
            if (!overviewList.contains { $0.id == result.id }) {
                modelcontext.insert(result)
            }
        }
    }
}

#Preview {
    BrowseView()
        .modelContainer(for: [ShowModel.self, ShowOverviewModel.self], inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
