//
//  SearchItemView.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI

struct SearchRowView: View {
    @Binding var show: ShowInfo
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: show.thumbnail ?? show.imageURL)!) {
                $0
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 15))
                    .frame(maxWidth: 100, maxHeight: 120)
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
                    .frame(maxWidth: 100, maxHeight: 120)
                    .padding()
            }
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            Spacer()
            VStack(alignment: .trailing) {
                Text(show.name)
                    .bold()
                Text(String(show.year))
            }
        }
    }
}

#Preview {
    SearchRowView(show: Binding.constant(ShowInfo.dummy))
}
