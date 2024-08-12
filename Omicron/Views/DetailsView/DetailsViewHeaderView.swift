//
//  DetailsViewHeader.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct DetailsViewHeader: View {
    @State var show: Show
    @Binding var ratingOverlayPresented: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: show.image)!) {image in
                image.resizable()
            } placeholder: {
                Text("Loading...")
            }
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            VStack(alignment: .trailing) {
                Spacer()
                Button(show.score == 0 ? "-" : String(show.score), systemImage: "star.fill") {
                    withAnimation {
                        ratingOverlayPresented = true
                    }
                }
                Text("Seasons: \(show.seasonCount)")
            }
            .padding(.vertical)
        }
        .frame(height: 200)
    }
}

#Preview {
    DetailsViewHeader(show: Show.exaple, ratingOverlayPresented: Binding.constant(false))
}
