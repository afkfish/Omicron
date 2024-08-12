//
//  ListViewItemLabel.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct ListViewItemLabel: View {
    @State var show: Show
    
    var body: some View {
        VStack {
            HStack {
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
    ListViewItemLabel(show: Show.exaple)
}
