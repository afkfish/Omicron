//
//  SearchDetailsHeaderView.swift
//  Omicron
//
//  Created by Beni Kis on 12/08/2024.
//

import SwiftUI

struct SearchDetailsHeaderView: View {
    @Binding var show: ShowOverviewModel
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: show.imageURL)!) {image in
                image.resizable()
            } placeholder: {
                Text("Loading...")
            }
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            VStack(alignment: .trailing) {
                Spacer()
                Text("Status: \(show.status)")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .frame(height: 200)
    }
}

#Preview {
    SearchDetailsHeaderView(show: Binding.constant(ShowOverviewModel.dummy))
}
