//
//  SearchItemDetails.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI
import SwiftData
import Combine

struct SearchDetailsView: View {
    @StateObject private var vm = SearchDetailViewModel()
    @EnvironmentObject private var theme: ThemeManager
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    
    @Binding var show: ShowOverviewModel
    @State private var addedSuccesfuly = false
    
    private var added: Bool {
        let id = "\(show.id)"
        let descriptor = FetchDescriptor<ShowModel>(predicate: #Predicate {$0.id == id})
        return !((try? modelContext.fetch(descriptor)) ?? []).isEmpty
    }
    
    var body: some View {
        ZStack {
            theme.selected.primary
                .ignoresSafeArea(.all)
            VStack {
                SearchDetailsHeaderView(show: $show)
                HStack {
                    Text(String(show.year))
                    Spacer()
                    Text("Language: \(show.primaryLang)")
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
                        guard !added else { return }
                        await vm.getShow(id: show.id)
                    }
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                .padding()
            }
            .onChange(of: vm.finished) {
                addedSuccesfuly = true
                saveShow()
            }
            .navigationTitle(show.name)
            .alert("Show added to list \(vm.show?.title ?? "")", isPresented: $addedSuccesfuly) {}
        }
        .onAppear {
            vm.setup(apiController: apiController)
        }
    }
    
    func saveShow() {
        modelContext.insert(vm.show!)

//        let test = try? modelContext.fetch(FetchDescriptor<EpisodeModel>())
//        print(test?.count ?? 0)
    }
}

#Preview {
    SearchDetailsView(show: Binding.constant(ShowOverviewModel.dummy))
        .modelContainer(for: [ShowModel.self], inMemory: true)
        .environmentObject(ThemeManager())
}
