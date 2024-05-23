//
//  ShowImageCard.swift
//  Omicron
//
//  Created by Beni Kis on 16/05/2024.
//

import SwiftUI

struct ShowImageCard: View {
    @Binding var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)!) {
            $0.resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ShowImageCard(url: Binding.constant("https://artworks.thetvdb.com/banners/posters/328724-2.jpg"))
}
