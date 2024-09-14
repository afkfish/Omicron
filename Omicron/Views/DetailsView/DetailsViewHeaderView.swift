//
//  DetailsViewHeader.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct DetailsViewHeader: View {
    @Binding var show: Show
    @Binding var ratingOverlayPresented: Bool
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: show.image)!) {image in
                image.resizable()
            } placeholder: {
                ProgressView()
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
    DetailsViewHeader(show: Binding.constant(Show.exaple), ratingOverlayPresented: Binding.constant(false))
}
