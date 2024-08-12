//
//  SeasonsView.swift
//  Omicron
//
//  Created by Beni Kis on 23/05/2024.
//

import SwiftUI

struct SeasonsListedView: View {
    @Binding var show: Show
    
    var body: some View {
        ScrollView {
            ForEach(Array(show.seasons.sorted {$0.key < $1.key}), id: \.key) {(key: Int, _) in
                SingleSeasonView(show: $show, key: key)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SeasonsListedView(show: Binding.constant(Show.exaple))
}
