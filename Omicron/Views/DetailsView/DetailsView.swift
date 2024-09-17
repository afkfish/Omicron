//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject private var theme: ThemeManager
    var show: ShowModel
    @State private var ratingOverlayPresented = false
    
    var body: some View {
        ZStack {
            theme.selected.primary
                .ignoresSafeArea(.all)
            VStack {
                header
                showInfo
                Text(show.overview ?? "")
                Spacer()
                SeasonsListedView(show: show)
            }
            .padding(.horizontal)
            .blur(radius: ratingOverlayPresented ? 3 : 0)
            .navigationTitle(show.title)
            ratingOverlay
        }
    }
    
    private var ratingOverlay: some View {
        Group {
            if (ratingOverlayPresented) {
                DetailsViewRatingOverlay(show: show, ratingOverlayPresented: $ratingOverlayPresented)
                    .environmentObject(theme)
            }
        }
    }
    
    private var showInfo: some View {
        VStack {
            HStack {
                Text(show.firstAirDate ?? "")
                Spacer()
                Text("Episode length: \(show.episodeLength ?? 0)m")
            }
            .padding(.top)
            HStack {
                Text("Overall progress: ")
                    .bold()
                Spacer()
                Text(/*String(show.progress.map {$0.value}.reduce(0, +))*/ "0" + "/" + String(show.seasons.map {$0.episodeCount}.reduce(0, +)))
            }
            .padding(.bottom)
        }
    }
    
    private var header: some View {
        HStack {
            posterImage
            Spacer()
            showStats
        }
        .frame(height: 200)
    }
    
    private var posterImage: some View {
        CachedAsyncImage(url: URL(string: show.posterPath ?? "")!) {image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var showStats: some View {
        VStack(alignment: .trailing) {
            Spacer()
            Button(/*show.score == 0 ? "-" : String(show.score)*/ "10", systemImage: "star.fill") {
                withAnimation {
                    ratingOverlayPresented = true
                }
            }
            Text("Seasons: \(show.seasons.count)")
        }
        .padding(.vertical)
    }
}

#Preview {
    DetailsView(show: ShowModel.sample)
        .environmentObject(ThemeManager())
}
