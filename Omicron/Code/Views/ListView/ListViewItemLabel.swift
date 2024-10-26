//
//  ListViewItemLabel.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct ListViewItemLabel: View {
    @AppStorage("countExtras") private var countExtras = true
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @State var show: ShowModel
    
    private var user: UserModel? {
        accountManager.currentAccount
    }
        
    private var userRating: Int {
        user?.ratings[show.id] ?? 0
    }
    
    private var progress: Float {
        var filtered = user?.progresses[show.id]
        if (!countExtras) {
            filtered = filtered?.filter { $0.key != 0 }
        }
        return Float(filtered?.values.reduce(0, +) ?? 0)
    }
    
    private var sumOfEpisodes: Float {
        if (countExtras) {
            Float(show.seasons.reduce(0) { $0 + $1.episodeCount })
        } else {
            Float(show.seasons.filter { $0.seasonNumber != 0 }.reduce(0) { $0 + $1.episodeCount })
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                CachedAsyncImage(url: URL(string: show.posterPath ?? "")!) {
                    $0.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 67.5, maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                }
                Text(show.title)
                Spacer()
                Text(userRating == 0 ? "-" : String(userRating))
            }
            HStack {
                ProgressView(value: progress, total: sumOfEpisodes)
                    .tint(theme.selected.accent)
            }
        }
    }
}

#Preview {
    ListViewItemLabel(show: ShowModel.sample)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
