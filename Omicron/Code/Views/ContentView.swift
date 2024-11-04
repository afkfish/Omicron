//
//  ContentView.swift
//  Omicron
//
//  Created by Beni Kis on 22/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    
    var body: some View {
        VStack {
            TabView {
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "globe") }.tag(1)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                
                ListsView()
                    .tabItem { Label("Library", systemImage: "list.star") }.tag(2)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person") }.tag(3)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }.tag(4)
                    .toolbarBackground(theme.selected.primary, for: .tabBar)
            }
        }
        .tint(theme.selected.accent)
        .onChange(of: scenePhase) {
            if (scenePhase != .active) {
                accountManager.save()
                Task {
                    do {
                        try await accountManager.syncUp()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ShowOverviewModel.self, ShowModel.self, UserModel.self], inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
