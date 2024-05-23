//
//  SingleSeasonView.swift
//  Omicron
//
//  Created by Beni Kis on 23/05/2024.
//

import SwiftUI

struct SingleSeasonView: View {
    @Binding var season: Season
    @State var key: Int
    @Binding var progress: [Int: Int]
    @State var collapsed = true
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    collapsed.toggle()
                } label: {
                    Label("Season \(key)", systemImage: collapsed ? "chevron.up" : "chevron.down")
                }
                Spacer()
                Button {
                    progress[key] = (progress[key] ?? 0) - (progress[key] ?? 0 > 0 ? 1: 0)
                } label: {
                    Image(systemName: "minus.circle.fill")
                }
                .buttonStyle(PlainButtonStyle())
                Text("\(progress[key] ?? 0)/\(season.episodeCount)")
                Button {
                    progress[key] = (progress[key] ?? 0) + (season.episodeCount > progress[key] ?? 0 ? 1 : 0)
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .buttonStyle(PlainButtonStyle())
            }
            VStack {
                ForEach(season.episodes) {episode in
                    HStack {
                        Text("Episode \(episode.episodeNumber)")
                        Spacer()
                        Text(episode.name)
                    }
                    .padding(.horizontal)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : nil)
            .clipped()
            .animation(.easeIn, value: 1)
            .transition(.slide)
        }
    }
}
