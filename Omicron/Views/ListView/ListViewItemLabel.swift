//
//  ListViewItemLabel.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct ListViewItemLabel: View {
    @Binding var show: Show
    
    var body: some View {
        VStack {
            HStack {
                CachedAsyncImage(url: URL(string: show.image)!) {
                    $0.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 67.5, maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                }
                Text(show.name)
                Spacer()
                Text(show.score == 0 ? "-" : String(show.score))
            }
            HStack {
                ProgressView(value: Float(show.progress.map {$0.value}.reduce(0, +)), total: Float(show.episodes))
                    .tint(.green)
            }
        }
    }
}

#Preview {
    ListViewItemLabel(show: Binding.constant(Show.exaple))
}
