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
    
    @ObservedObject private var auth = AuthStore()
    
    var body: some View {
        TabView {
//            if (auth.data.authenticated || auth.data.cancelledLogin) {
                ListsView()
                    .tabItem { Label("Lists", systemImage: "list.star") }.tag(1)
                    .toolbarBackground(Color.offWhite, for: .tabBar)
                
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "globe") }.tag(2)
                    .toolbarBackground(Color.offWhite, for: .tabBar)
                
//            } else {
//                LandingView()
//            }
//                .tabItem { Label("Profile", systemImage: "person") }.tag(3)
//                .toolbarBackground(Color.offWhite, for: .tabBar)
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
