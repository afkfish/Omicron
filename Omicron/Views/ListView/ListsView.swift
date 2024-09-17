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
    @EnvironmentObject private var theme: ThemeManager
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [ShowModel]
    @ObservedObject private var vm = ListsViewModel()
    
//    @Binding var currentUser: UserModel?
    @State private var searchText = ""
        
    var body: some View {
        NavigationStack {
            ZStack {
                theme.selected.primary
                    .ignoresSafeArea(.all)
                List {
                    ForEach(searchResults) {show in
//                        @State var show = show // bad practice, pls no bully /(0_0*)\
                        NavigationLink {
                            DetailsView(show: show)
                                .environmentObject(theme)
                        } label: {
                            ListViewItemLabel(show: show)
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Title of the show")
                .navigationTitle("Saved")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .onAppear {
                vm.start(modelContext: modelContext)
            }
        }
    }
    
//    var userShows: [Show] {
//        if AuthStore().data.authenticated {
//            return shows.filter {show in
//                FireStore.shared.user!.lists["favourites"]!.contains(String(show.id))
//            }
//        } else {
//            return shows
//        }
//    }
    
    var searchResults: [ShowModel] {
        if searchText.isEmpty {
            return shows
        } else {
            return shows.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ListsView()
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
}
