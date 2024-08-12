//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct DetailsView: View {
    @Binding var show: Show
    @State private var ratingOverlayPresented = false
    
    var body: some View {
        ZStack {
            Color.offWhite
                .ignoresSafeArea(.all)
            VStack {
                DetailsViewHeader(show: $show, ratingOverlayPresented: $ratingOverlayPresented)
                HStack {
                    Text(show.firstAired)
                    Spacer()
                    Text("Episode length: \(show.runningTimeInMinutes)m")
                }
                .padding(.top)
                HStack {
                    Text("Overall progress: ")
                        .bold()
                    Spacer()
                    Text(String(show.progress.map {$0.value}.reduce(0, +)) + "/" + String(show.episodes))
                }
                .padding(.bottom)
                Text(show.desc)
                Spacer()
                SeasonsListedView(show: $show)
            }
            .padding(.horizontal)
            .blur(radius: ratingOverlayPresented ? 3 : 0)
            .navigationTitle(show.name)
            if (ratingOverlayPresented) {
                DetailsViewRatingOverlay(show: $show, ratingOverlayPresented: $ratingOverlayPresented)
            }
        }
    }
}

#Preview {
    DetailsView(show: Binding.constant(Show.exaple))
}
