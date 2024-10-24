//
//  LoginView.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import SwiftUI
import SwiftData

struct LoginRegisterView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.defaultAPIController) private var apiController
    @ObservedObject private var vm = LoginRegisterViewModel()
    
    var isSignup: Bool
    
    @State private var username: String = ""
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
                if (isSignup) {
                    TextField("", text: $username, prompt: Text("username"))
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                }
                TextField("", text: $email, prompt: Text("email"))
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                SecureField("", text: $password, prompt: Text("password"))
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                Spacer()
                Button {
                    if (!email.isEmpty || !password.isEmpty) {
                        Task {
                            do {
                                if isSignup {
                                    try await vm.register(username: username, email: email, password: password)
                                } else {
                                    try await vm.login(email: email, password: password)
                                }
                            } catch {
                                alertText = error.localizedDescription
                                alertToggle.toggle()
                            }
                        }
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
            vm.start(apiController, accountManager, modelContext.container)
        }
    }
}

#Preview {
    LoginRegisterView(isSignup: true)
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
