//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct DetailsView: View {
    @AppStorage("countExtras") private var countExtras = true
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @State var show: ShowModel
    @State private var ratingOverlayPresented = false
    
    private var user: UserModel? {
        accountManager.currentAccount
    }
    
    private var userRating: Int {
        user?.ratings[show.id] ?? 0
    }
    
    private var progress: Int {
        if (countExtras) {
            user?.progresses[show.id]?.values.reduce(0, +) ?? 0
        } else {
            user?.progresses[show.id]?.filter { $0.key != 0 }.values.reduce(0, +) ?? 0
        }
    }
    
    private var sumOfEpisodes: Int {
        if (countExtras) {
            show.seasons.reduce(0) { $0 + $1.episodeCount }
        } else {
            show.seasons.filter { $0.seasonNumber != 0 }.reduce(0) { $0 + $1.episodeCount }
        }
    }
    
    var body: some View {
        ZStack {
            theme.selected.primary
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    header
                    showInfo
                    Text(show.overview ?? "")
                    Spacer()
                    ForEach(Array(show.seasons.sorted(by: >))) {
                        SingleSeasonView(show: $show, key: $0.seasonNumber)
                    }
                }
            }
            .padding(.horizontal)
            .blur(radius: ratingOverlayPresented ? 3 : 0)
            .navigationTitle(show.title)
            .toolbarBackground(theme.selected.primary, for: .navigationBar)
            ratingOverlay
        }
    }
    
    private var ratingOverlay: some View {
        Group {
            if (ratingOverlayPresented) {
                DetailsViewRatingOverlay(show: $show, ratingOverlayPresented: $ratingOverlayPresented)
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
                Text(String(progress) + "/" + String(sumOfEpisodes))
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
            Button(userRating == 0 ? "-" : String(userRating), systemImage: "star.fill") {
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
        .environmentObject(AccountManager())
}
