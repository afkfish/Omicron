//
//  SingleSeasonView.swift
//  Omicron
//
//  Created by Beni Kis on 13/08/2024.
//

import SwiftUI

struct SingleSeasonView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @State private var collapsed = true
    @Binding var show: ShowModel
    var key: Int
    
    private var user: UserModel? { accountManager.currentAccount }
    private var season: SeasonModel? { show.seasons.first(where: {$0.seasonNumber == key}) }
    private var seasonProgress: Int { user?.fetchOrCreateProgress(withId: show.id, forSeason: key) ?? 0 }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    collapsed.toggle()
                } label: {
                    Label(key == 0 ? "Extras" : "S\(String(format: "%02d", key))", systemImage: collapsed ? "chevron.down" : "chevron.up")
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                ProgressView(value: Float(seasonProgress), total: Float(season?.episodeCount ?? 0))
                    .tint(theme.selected.accent)
                Spacer()
                HStack {
                    Button {
                        withAnimation(.bouncy) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            user?.progresses[show.id]?[key] = (seasonProgress) - (seasonProgress > 0 ? 1: 0)
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                    .disabled(seasonProgress <= 0)
                    .buttonStyle(PlainButtonStyle())
                    Text("\(seasonProgress)/\(season?.episodeCount ?? 0)")
                    Button {
                        withAnimation(.bouncy) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            user?.progresses[show.id]?[key] = (seasonProgress) + (season?.episodeCount ?? 0 > seasonProgress ? 1 : 0)                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(seasonProgress >= season?.episodeCount ?? 0)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical)
            .contentShape(Rectangle())
            .contextMenu(ContextMenu(menuItems: {
                Button {
                    withAnimation(.bouncy) {
                        user?.progresses[show.id]?[key] = season?.episodeCount ?? 0
                    }
                } label: {
                    Label("Mark as watched", systemImage: "checkmark.circle.fill")
                }
                Button {
                    withAnimation(.bouncy) {
                        user?.progresses[show.id]?[key] = 0
                    }
                } label: {
                    Label("Mark as unwatched", systemImage: "x.circle.fill")
                }
            }))
            VStack {
                ForEach(season?.episodes.sorted() ?? []) {(episode: EpisodeModel) in
                    HStack {
                        Text("E\(String(format: "%02d", episode.episodeNumber))")
                        Text("\(episode.title)").bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    if episode.id != season?.episodes.last?.id { // Don't add Divider after last item
                        Divider()
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : nil)
            .clipped()
            .animation(.easeIn, value: 1)
            .transition(.slide)
        }
    }
}

#Preview {
    SingleSeasonView(show: Binding.constant(ShowModel.sample), key: 1)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
