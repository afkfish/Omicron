//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct DetailsView: View {
    @Binding var show: Show
    
    var body: some View {
        VStack {
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
//                    Text(show.name)
//                        .bold()
//                        .padding(.bottom)
                    Label(String(show.score), systemImage: "star.fill")
                    Text("Seasons: \(show.seasonCount)")
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            .frame(height: 200)
            HStack {
                Text(show.airDate)
                Spacer()
                Text(show.rating)
                Spacer()
                Text(show.episodeLength)
            }
            .padding(.top)
            .padding(.horizontal)
            HStack {
                Text("Episode count: ")
                    .bold()
                Spacer()
                Text(String(show.episodes))
            }
            .padding(.horizontal)
            .padding(.bottom)

            Text(show.desc)
                .padding(.horizontal)
            
            
            Spacer()
        }
        .navigationTitle(show.name)
    }
}

#Preview {
    DetailsView(show: Binding.constant(Show.exaple))
}
