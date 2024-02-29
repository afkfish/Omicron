//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct ShowDetailsView: View {
    @Binding var show: Show
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: show.image)!) {image in
                image.resizable()
            } placeholder: {
                Text(show.image)
            }
            HStack(alignment: .center) {
                Text(show.name)
            }
        }
    }
}

#Preview {
    ShowDetailsView(show: Binding.constant(Show.exaple))
}
