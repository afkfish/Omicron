//
//  ContentView.swift
//  Omicron
//
//  Created by Beni Kis on 22/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var theme = ThemeManager()
    @StateObject private var accountManager = AccountManager()
    @AppStorage("loginCancelled") private var loginCancelled = false
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject private var auth = AuthStore()
    
    var body: some View {
        TabView {
            if (loginCancelled) {
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "globe") }.tag(1)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                    .environmentObject(theme)
                
                ListsView()
                    .tabItem { Label("Lists", systemImage: "list.star") }.tag(2)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                    .environmentObject(theme)
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }.tag(3)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                    .environmentObject(theme)
                
            } else {
                LandingView()
                    .environmentObject(theme)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ShowOverviewModel.self, ShowModel.self], inMemory: true)
}
