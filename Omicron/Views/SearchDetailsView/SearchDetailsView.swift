//
//  SearchItemDetails.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI
import SwiftData

struct SearchDetailsView: View {
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var vm = SearchDetailViewModel()

    @Binding var show: ShowInfo
    @State private var addedSuccesfuly = false

    var body: some View {
        ZStack {
            Color.offWhite
                .ignoresSafeArea(.all)
            VStack {
                SearchDetailsHeaderView(show: $show)
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
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    Task {
                        await vm.addShow(id: Int(show.id)!, apiController)
                    }
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                .padding()
            }
            .onChange(of: vm.show) {
                if vm.show != nil {
                    saveShow()
                    addedSuccesfuly = true
                }
            }
            .navigationTitle(show.name)
            .alert("Show added to list", isPresented: $addedSuccesfuly) {}
        }
    }
    
    func saveShow() {
        modelContext.insert(vm.show!)
    }
}

#Preview {
    SearchDetailsView(show: Binding.constant(ShowInfo.dummy))
        .modelContainer(for: Show.self, inMemory: true)
}
