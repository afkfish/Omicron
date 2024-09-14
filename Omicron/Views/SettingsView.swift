//
//  Settings.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var alert = false
    @State private var cacheCleared = false
    @State private var selectedThemeType: ThemeType = .elephant
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Picker("Select theme", selection: $selectedThemeType) {
                            ForEach(ThemeType.allCases, id: \.self) { themeType in
                                Text(themeType.theme.name).tag(themeType)
                            }
                        }
                        .pickerStyle(.menu)
                        .listRowBackground(theme.selected.secondary)
                        .onChange(of: selectedThemeType) {
                            theme.setTheme(selectedThemeType)
                        }
                    } header: {
                        Text("UI")
                    }
                    
                    Section {
                        Button {
                            cacheCleared = ImageCache.shared.clearCache()
                            alert = true
                        } label: {
                            Text("Clear cache")
                        }
                        .listRowBackground(theme.selected.secondary)
                    } header: {
                        Text("System")
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
            .alert(cacheCleared ? "Cache cleared!" : "Error!", isPresented: $alert) {}
            .background(theme.selected.primary)
            .onAppear {
                selectedThemeType = theme.getType()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
