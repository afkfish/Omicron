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
        ZStack {
            Color.offWhite
                .ignoresSafeArea(.all)
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
                        Label(String(show.score), systemImage: "star.fill")
                        Text("Seasons: \(show.seasonCount)")
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                .frame(height: 200)
                HStack {
                    Text(show.firstAired)
                    Spacer()
                    Text(String(show.score))
                    Spacer()
                    Text("Episode length: \(show.runningTimeInMinutes)m")
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
}

#Preview {
    DetailsView(show: Binding.constant(Show.exaple))
}
