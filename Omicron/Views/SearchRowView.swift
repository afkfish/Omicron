//
//  SearchItemView.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var item: ShowInfo
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.thumbnail ?? item.imageURL)!) {
                $0
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100, maxHeight: 120)
                    .clipShape(.rect(cornerRadius: 10))
            } placeholder: {
                Text("Loading")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.name)
                    .bold()
                Text(String(item.year))
            }
        }
    }
}
