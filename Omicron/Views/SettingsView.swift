//
//  Settings.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("loginCancelled") private var loginCancelled = false
    @AppStorage("countExtras") private var countExtras = true
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @State private var alert = false
    @State private var cacheCleared = false
    @State private var countExtrasState = true
    @State private var selectedThemeType: ThemeType = .gallery
    
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
                        Button {
                            loginCancelled = false
                            accountManager.currentAccount = nil
                        } label: {
                            Text("Logout")
                        }
                        .listRowBackground(theme.selected.secondary)
                        Toggle(isOn: $countExtrasState) {
                            Text("Count extras")
                        }
                        .onChange(of: countExtrasState) {
                            countExtras.toggle()
                        }
                        .tint(theme.selected.contrast)
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
        .environmentObject(AccountManager())
}
