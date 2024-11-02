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
                        vm.search(apiController, query: searchPhrase)
                    }
                }
                .onChange(of: vm.isFinished) {
                    if (vm.isFinished) {
                        vm.appendResults(overviewList: overviewList, modelContainer: modelcontext.container)
                        vm.isFinished = false
                    }
                }
                .navigationTitle("Browse")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .background(theme.selected.primary)
        }
    }
}

#Preview {
    BrowseView()
        .modelContainer(for: [ShowModel.self, ShowOverviewModel.self], inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
