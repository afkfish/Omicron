//
//  DetailsViewRatingOverlay.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct DetailsViewRatingOverlay: View {
    @EnvironmentObject private var accountManager: AccountManager
    @EnvironmentObject private var theme: ThemeManager
    @Environment(\.modelContext) private var modelContext
    @State private var rating = 0.0
    @Binding var show: ShowModel
    @Binding var ratingOverlayPresented: Bool
    
    private var user: UserModel? {
        accountManager.currentAccount!
    }
    
    private var userRating: Int {
        user?.ratings[show.id] ?? 0
    }
    
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
            rating = Double(userRating)
        }
    }
    
    private func saveRating() {
        user?.ratings[show.id] = Int(rating)
    }
}

#Preview {
    DetailsViewRatingOverlay(show: Binding.constant(ShowModel.sample), ratingOverlayPresented: Binding.constant(false))
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
