//
//  SeasonsView.swift
//  Omicron
//
//  Created by Beni Kis on 23/05/2024.
//

import SwiftUI

struct SeasonsView: View {
    @State var show: Show
    
    var body: some View {
        ScrollView {
            ForEach(Array(show.seasons), id: \.key) {(key: Int, season: Season) in
                @State var se = show.seasons[key]!
                SingleSeasonView(season: $se, key: key, progress: $show.progress)
            }
            .padding()
        }
    }
}

#Preview {
    SeasonsView(show: Show.exaple)
}
