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
            Text("Tab Content 2").tabItem { Label("Profile", systemImage: "person") }.tag(2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Show.self, inMemory: true)
}
