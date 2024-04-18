//
//  SearchItemDetails.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI
import SwiftData

struct SearchItemDetailsView: View {
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]

    @Binding var show: ShowInfo
    
    @State private var addedSuccesfuly = false

    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: show.imageURL)!) {image in
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
            HStack {
                Text(String(show.year))
                Spacer()
                Text("Language: \(show.primaryLang)m")
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom)
            ScrollView {
                Text(show.overview ?? "")
                    .padding(.horizontal)
            }
            Spacer()
            Button("Add show to list") {
                addShow(id: Int(show.id)!)
            }
        }
        .alert("Show added to list", isPresented: $addedSuccesfuly) {}
    }
    
    private func addShow(id: Int) {
        if (!shows.contains {$0.id == id}) {
            apiController.getSeries(id: id) {
                addedSuccesfuly = true
                let sh = Show(from: $0)
                withAnimation {
                    modelContext.insert(sh)
                }
            }
        }
    }
}

#Preview {
    SearchItemDetailsView(show: Binding.constant(ShowInfo.dummy))
        .modelContainer(for: Show.self, inMemory: true)
}
