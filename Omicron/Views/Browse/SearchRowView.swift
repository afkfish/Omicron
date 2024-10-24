//
//  SearchItemView.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI

struct SearchRowView: View {
    @State var show: ShowOverviewModel
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: show.thumbnail ?? show.imageURL)!) {
                $0.resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 15))
                    .frame(maxWidth: 100, maxHeight: 120)
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
                    .frame(width: 100, height: 120)
                    .padding()
            }
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
    SearchRowView(show: ShowOverviewModel.dummy)
}
