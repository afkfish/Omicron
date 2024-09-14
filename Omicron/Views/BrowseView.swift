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
    @Query(sort: \ShowInfo.name, order: .forward) private var baseDetails: [ShowInfo]
    @ObservedObject private var vm = BrowseViewModel()
    
    var filteredSearchItems: [ShowInfo] {
        if (vm.searchText.isEmpty) {
            baseDetails
        } else {
            baseDetails.filter { $0.name.lowercased().contains(vm.searchText.lowercased()) }
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
                            SearchDetailsView(show: Binding.constant(item))
                        } label: {
                            SearchRowView(show: Binding.constant(item))
                        }
                        .padding()
                        .background(theme.selected.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .padding(.vertical, 12)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $vm.searchText, prompt: "Search for a show")
                .onChange(of: vm.searchText) {
                    if (filteredSearchItems.count < 10) {
                        Task {
                            await vm.search(apiController)
                        }
                    }
                }
                .navigationTitle("Browse")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .onAppear {
                vm.start(modelContext: modelcontext)
            }
            .background(theme.selected.primary)
        }
    }
}

#Preview {
    BrowseView()
        .modelContainer(for: [Show.self, ShowInfo.self], inMemory: true)
        .environmentObject(ThemeManager())
}
