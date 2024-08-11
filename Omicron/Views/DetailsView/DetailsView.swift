//
//  ShowDetailsView.swift
//  Omicron
//
//  Created by Beni Kis on 25/02/2024.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var show: Show
    @State private var ratingOverlayPresented = false
    @State private var rating = 0.0
    
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
                        Button(show.score == 0 ? "-" : String(show.score), systemImage: "star.fill") {
                            ratingOverlayPresented = true
                        }
                        Text("Seasons: \(show.seasonCount)")
                    }
                    .padding(.vertical)
                }
                .frame(height: 200)
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
                SeasonsView(show: $show)
            }
            .padding(.horizontal)
            .blur(radius: ratingOverlayPresented ? 3 : 0)
            .navigationTitle(show.name)
            if (ratingOverlayPresented) {
                VStack{
                    Slider(value: $rating, in: 0...10, step: 1) {
                        Text("Rate the show")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("10")
                    }
                    Spacer()
                    Text(String(Int(rating)))
                    Spacer()
                    HStack {
                        Button("Cancel") {
                            withAnimation {
                                ratingOverlayPresented = false
                            }
                        }
                        .buttonStyle(BorderedButtonStyle())
                        Spacer()
                        Button("Rate") {
                            saveRating()
                            ratingOverlayPresented = false
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
                .padding(15)
                .frame(maxWidth: 300, maxHeight: 150)
                .background(Color.offWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 10)
            }
        }
        .onAppear {
            rating = Double(show.score)
        }
    }
    
    private func saveRating() {
        do {
            show.score = Int(rating)
            try modelContext.save()
        } catch {
            print("Oops")
        }
    }
}

#Preview {
    DetailsView(show: Binding.constant(Show.exaple))
}
