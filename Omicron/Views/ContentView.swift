//
//  ContentView.swift
//  Omicron
//
//  Created by Beni Kis on 22/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        TabView {
            ListsView()
                .tabItem { Label("Lists", systemImage: "list.star") }.tag(1)
                .toolbarBackground(Color.offWhite, for: .tabBar)

            BrowseView()
                .tabItem { Label("Browse", systemImage: "globe") }.tag(2)
                .toolbarBackground(Color.offWhite, for: .tabBar)

            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    Text("Tab Content 2")
                    Spacer()
                }
                Spacer()
            }
            .background(Color.offWhite)
            .tabItem { Label("Profile", systemImage: "person") }.tag(3)
        }

    }
    
    func addDebug() {
        modelContext.insert(Show.exaple)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Show.self, ShowInfo.self], inMemory: true)
}
