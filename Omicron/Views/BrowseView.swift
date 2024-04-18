//
//  BrowseView.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import SwiftUI
import SwiftData

struct BrowseView: View {
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShowInfo.name, order: .forward) private var baseDetails: [ShowInfo]
    
    @State private var searchItems: Array<ShowInfo> = Array()
    @State private var searchText: String = ""
    
    @State private var popular: [String]?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(filteredSearchItems) {item in
                        NavigationLink {
                            SearchDetailsView(show: Binding.constant(item))
                        } label: {
                            SearchRowView(show: Binding.constant(item))
                        }
                        .padding()
                        .background(Color.offWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .padding(.vertical, 12)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowBackground(Color.offWhite)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Search show")
                .onSubmit(of: .search) {
                    apiController.search(for: searchText) {searchResult in
                        addSearchItems(searchResult: searchResult)
                    }
                }
                .onAppear {
                    if (searchItems.isEmpty) {
                        apiController.search(for: "A") {searchResult in
                            addSearchItems(searchResult: searchResult)
                        }
                    }
                }
                .navigationTitle("Browse")
                .toolbarBackground(Color.offWhite, for: .navigationBar)
            }
            .background(Color.offWhite)
        }
        
    }
    
    private var filteredSearchItems: [ShowInfo] {
        if (searchText.isEmpty) {
            searchItems
        } else {
            searchItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func addShow(show: Show) {
        withAnimation {
            modelContext.insert(show)
        }
    }
    
    private func addSearchItems(searchResult: SearchDTO) {
        withAnimation {
            searchResult.data?.forEach {item in
                if (!searchItems.contains(where: {$0.name == item.name})) {
                    searchItems.append(ShowInfo(from: item))
                }
            }
            searchItems.sort(by: {$0.name < $1.name})
        }
    }
    
    private func deleteShowInfos() {
        withAnimation {
            searchItems.removeAll()
        }
    }
}

#Preview {
    BrowseView()
        .modelContainer(for: [Show.self, ShowInfo.self], inMemory: true)
}
