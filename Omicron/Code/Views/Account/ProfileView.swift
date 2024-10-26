//
//  ProfileView.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var library: [ShowModel]
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    
    private var user: UserModel? {
        accountManager.currentAccount
    }
    
    private var totalProgress: Int {
        user?.progresses.reduce(0) { $0 + $1.value.values.reduce(0, +) } ?? 0
    }
    
    private var totalWatchTime: Int {
        user?.progresses.map { progress in
            let lenght = user?.library.first { $0.id == progress.key }?.episodeLength ?? 0
            return progress.value.values.reduce(0, +) * lenght
        }.reduce(0, +) ?? 0
    }
    
    private var totalWatchTimeText: String {
        if totalWatchTime < 60 {
            return "\(totalWatchTime)m"
        } else if totalWatchTime < 1440 {
            let hours = totalWatchTime / 60
            return "\(hours)h"
        } else {
            let days = totalWatchTime / 1440
            return "\(days)d"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(user?.username.uppercased() ?? "Offline")
                        .font(.title)
                }
                List {
                    Section {
                        HStack {
                            Text("Watch count")
                            Spacer()
                            Text("\(totalProgress)")
                        }.listRowBackground(theme.selected.secondary)
                        HStack {
                            Text("Watch time")
                            Spacer()
                            Text(totalWatchTimeText)
                        }.listRowBackground(theme.selected.secondary)
                    } header: {
                        Text("Statistics")
                    }
                    HStack {
                        Spacer()
                        Button {
                            logout()
                        } label: {
                            Text(accountManager.currentAccount?.isOffline ?? true ? "Login to cloud" : "Logout")
                        }
                        .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                        Spacer()
                    }
                    .padding()
                    .listRowBackground(theme.selected.primary)
                }
                .scrollContentBackground(.hidden)
            }
            .background(theme.selected.primary)
            .navigationTitle("Profile")
            .toolbarBackground(theme.selected.primary, for: .navigationBar)
        }
    }
    
    private func logout() {
        Task {
            accountManager.save()
            try? await accountManager.syncUp()
            accountManager.currentAccount = nil
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
