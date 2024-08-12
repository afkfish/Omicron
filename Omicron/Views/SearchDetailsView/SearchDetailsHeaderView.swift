//
//  SearchDetailsHeaderView.swift
//  Omicron
//
//  Created by Beni Kis on 12/08/2024.
//

import SwiftUI

struct SearchDetailsHeaderView: View {
    @State var show: ShowInfo
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: show.imageURL)!) {image in
                image.resizable()
            } placeholder: {
                Text("Loading...")
            }
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
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
    SearchDetailsHeaderView(show: ShowInfo.dummy)
}
