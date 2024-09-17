//
//  SingleSeasonView.swift
//  Omicron
//
//  Created by Beni Kis on 13/08/2024.
//

import SwiftUI

struct SingleSeasonView: View {
    @State private var collapsed = true
    var show: ShowModel
    var key: Int
    
    private var season: SeasonModel? { show.seasons.first(where: {$0.seasonNumber == key}) }
    private var seasonProgress: Int { /*show.progress[key] ??*/ 0 }
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    collapsed.toggle()
                } label: {
                    Label("S\(String(format: "%02d", key))", systemImage: collapsed ? "chevron.down" : "chevron.up")
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                ProgressView(value: Float(seasonProgress), total: Float(season?.episodeCount ?? 0))
                    .tint(.green)
                Spacer()
                HStack {
                    Button {
                        withAnimation(.bouncy) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                            show.progress[key] = (seasonProgress) - (seasonProgress > 0 ? 1: 0)
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
//                            show.progress[key] = (seasonProgress) + (season.episodeCount > seasonProgress ? 1 : 0)
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(seasonProgress >= season?.episodeCount ?? 0)
                    .buttonStyle(PlainButtonStyle())
                }
//                .frame(minWidth: 70, maxWidth: 100)
            }
            .padding(.vertical)
            .contentShape(Rectangle())
            .contextMenu(ContextMenu(menuItems: {
                Button {
                    withAnimation(.bouncy) {
//                        show.progress[key] = season.episodeCount
                    }
                } label: {
                    Label("Mark as watched", systemImage: "checkmark.circle.fill")
                }
                Button {
                    withAnimation(.bouncy) {
//                        show.progress[key] = 0
                    }
                } label: {
                    Label("Mark as unwatched", systemImage: "x.circle.fill")
                }
            }))
            VStack {
                ForEach(season?.episodes ?? []) {(episode: EpisodeModel) in
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
    SingleSeasonView(show: ShowModel.sample, key: 1)
}
