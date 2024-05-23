//
//  LoginView.swift
//  Omicron
//
//  Created by Beni Kis on 25/04/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.defaultAPIController) private var apiController
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var vm = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.offWhite
                    .ignoresSafeArea(.all)
                VStack {
                    VStack {
                        Spacer()
                        TextField("", text: $vm.email, prompt: Text("email"))
                            .padding()
                            .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                        SecureField("", text: $vm.password, prompt: Text("password"))
                            .padding()
                            .background(Background(isPressed: false, shape: RoundedRectangle(cornerRadius: 15)))
                        Spacer()
                        Button {
                            if (!vm.email.isEmpty || !vm.password.isEmpty) {
                                Task {
                                    await vm.authenticate(email: vm.email, password: vm.password)
                                }
                            } else {
                                vm.alertText = "Missing credentials!"
                                vm.alertToggle.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.right")
                        }
                        .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15)))
                        Spacer()
                    }
                    .padding(.horizontal, 80)
                }
                .alert(vm.alertText, isPresented: $vm.alertToggle) {}
                .navigationTitle("Login")
                .toolbarBackground(Color.offWhite, for: .navigationBar)
            }
            .onAppear {
                vm.start(modelContext: modelContext, apiController: apiController)
            }
        }
    }
}

#Preview {
    LoginView()
        .modelContainer(for: Show.self, inMemory: true)
}