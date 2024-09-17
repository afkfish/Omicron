//
//  SeasonsView.swift
//  Omicron
//
//  Created by Beni Kis on 23/05/2024.
//

import SwiftUI

struct SeasonsListedView: View {
    var show: ShowModel
    
    var body: some View {
        ScrollView {
            ForEach(Array(show.seasons.sorted { $0.seasonNumber < $1.seasonNumber})) {
                SingleSeasonView(show: show, key: $0.seasonNumber)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SeasonsListedView(show: ShowModel.sample)
}
