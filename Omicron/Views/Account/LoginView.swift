//
//  LoginView.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var vm = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertText: String = ""
    @State private var alertToggle: Bool = false
    
    var body: some View {
        ZStack {
            theme.selected.primary
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                TextField("", text: $email, prompt: Text("email"))
                    .padding()
                    .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                SecureField("", text: $password, prompt: Text("password"))
                    .padding()
                    .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                Spacer()
                Button {
                    if (!email.isEmpty || !password.isEmpty) {
                        login(email: email, password: password)
                    } else {
                        alertText = "Missing credentials!"
                        alertToggle.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                Spacer()
            }
            .padding(.horizontal, 80)
            .alert(alertText, isPresented: $alertToggle) {}
            .navigationTitle("Login")
            .toolbarBackground(theme.selected.primary, for: .navigationBar)
        }
        .onAppear {
            vm.start(apiController: apiController)
        }
        .onChange(of: vm.finishedAll) {
            accountManager.currentAccount!.library += vm.showResults
        }
    }
    
    private func login(email: String, password: String) {
        Task {
            do {
                let (onlineUserModel, library) = try await accountManager.loginWithFirebase(email: email, password: password)
                onlineUserModel.library = try await resloveLibrary(library)
                accountManager.switchToAccount(onlineUserModel)
            } catch {
                print(error)
            }
        }
    }
    
    private func resloveLibrary(_ library: [String]) async throws -> [ShowModel] {
        let offlineResults = try modelContext.fetch(FetchDescriptor<ShowModel>(predicate: #Predicate { library.contains($0.id) }))
        vm.getShows(ids: library.filter { id in !offlineResults.contains { $0.id == id } })
        return offlineResults
    }
}

#Preview {
    LoginView()
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
