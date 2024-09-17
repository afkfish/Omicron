//
//  ListViewItemLabel.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct ListViewItemLabel: View {
    var show: ShowModel
    
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
                Text(/*show.score == 0 ? "-" : String(show.score)*/"10")
            }
            HStack {
                ProgressView(value: /*Float(show.progress.map {$0.value}.reduce(0, +))*/0, total: Float(show.seasons.map {$0.episodes.count}.reduce(0, +)))
                    .tint(.green)
            }
        }
    }
}

#Preview {
    ListViewItemLabel(show: ShowModel.sample)
}
