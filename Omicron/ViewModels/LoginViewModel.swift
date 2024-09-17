//
//  LoginViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 14/05/2024.
//

import Foundation
import SwiftUI
import SwiftData

class LoginViewModel: ObservableObject {
    private var shows: [String] = []
    var modelContext: ModelContext?
    var apiController: APIController?
    
    @StateObject var sdvm = SearchDetailViewModel()
    
    @Published var email = ""
    @Published var password = ""
    @Published var alertText = ""
    @Published var alertToggle = false
    
    func start(modelContext: ModelContext, apiController: APIController) {
        self.modelContext = modelContext
        self.apiController = apiController
        sdvm.setup(apiController: apiController)
        loadData()
    }
    
    func loadData() {
        do {
            shows = try modelContext!.fetch(FetchDescriptor<ShowModel>()).map{String($0.id)}
        } catch {
            print(error)
        }
    }
    
    func authenticate(email: String, password: String) async {
        do {
            try await AuthProvider.shared.login(email: email, password: password)
            let user = try await FireStore.shared.getUserData()
            print(user)
            user.lists["favourites"]?.forEach {id in
                if !shows.contains(id) {
                    Task {
                        await sdvm.getShow(id: id)
                    }
                }
            }
//                alertText = "Logged in succesfuly"
//                alertToggle.toggle()
        } catch {
            DispatchQueue.main.sync {
                alertText = error.localizedDescription
                alertToggle.toggle()
            }
        }
    }
}
