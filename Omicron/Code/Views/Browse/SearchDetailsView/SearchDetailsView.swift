//
//  SearchItemDetails.swift
//  Omicron
//
//  Created by Beni Kis on 30/03/2024.
//

import SwiftUI
import SwiftData

struct SearchDetailsView: View {
    @StateObject private var vm = SearchDetailViewModel()
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    
    @State var show: ShowOverviewModel
    @State private var addedSuccesfuly = false
    
    private var added: (Bool, ShowModel?) {
        let id = "\(show.id)"
        let descriptor = FetchDescriptor<ShowModel>(predicate: #Predicate {$0.id == id})
        let fetchResult = try? modelContext.fetch(descriptor)
        return (!(fetchResult ?? []).isEmpty, fetchResult?.first)
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
                Button("Add show to library") {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    if !added.0 {
                        vm.getShow(id: show.id)
                    } else {
                        vm.addToUserLibrary(show: added.1!)
                        addedSuccesfuly.toggle()
                    }
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                .padding()
                .accessibilityIdentifier("AddToLibraryButton")
            }
            .onChange(of: vm.finished) {
                addedSuccesfuly = true
                vm.saveShow(modelContainer: modelContext.container)
            }
            .navigationTitle(show.name)
            .alert("Show added to library", isPresented: $addedSuccesfuly) {}
        }
        .onAppear {
            vm.setup(apiController: apiController, accountManager: accountManager)
        }
    }
}

#Preview {
    SearchDetailsView(show: ShowOverviewModel.dummy)
        .modelContainer(for: [ShowModel.self], inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
