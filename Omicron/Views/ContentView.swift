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

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: Show.self, inMemory: true)
}
