//
//  DetailsViewRatingOverlay.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct DetailsViewRatingOverlay: View {
    @EnvironmentObject private var theme: ThemeManager
    @Environment(\.modelContext) private var modelContext
    @State private var rating = 0.0
    @Binding var show: Show
    @Binding var ratingOverlayPresented: Bool
    
    var body: some View {
        VStack{
            Slider(value: $rating, in: 0...10, step: 1) {
                Text("Rate the show")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("10")
            }
            .onChange(of: rating) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            Spacer()
            Text(String(Int(rating)))
            Spacer()
            HStack {
                Button("Cancel") {
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        ratingOverlayPresented = false
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                Spacer()
                Button("Rate") {
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        saveRating()
                        ratingOverlayPresented = false
                    }
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
        .padding(15)
        .frame(maxWidth: 300, maxHeight: 150)
        .background(theme.selected.primary)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
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
    DetailsViewRatingOverlay(show: Binding.constant(Show.exaple), ratingOverlayPresented: Binding.constant(false))
        .environmentObject(ThemeManager())
}
