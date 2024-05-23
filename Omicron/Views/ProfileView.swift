//
//  ProfileView.swift
//  Omicron
//
//  Created by Beni Kis on 24/04/2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var email: String = "test2@test.com"
    @State private var password: String = "testpass"
    
    @State private var errorText: String = ""
    @State private var errorToggle: Bool = false
    
    var body: some View {
        VStack {
            Text("Login")
                .bold()
            TextField("email", text: $email).textFieldStyle(.roundedBorder)
            TextField("password", text: $password).textFieldStyle(.roundedBorder)
            
            Button("Submit") {
                Task {
                    do {
                        try await AuthProvider.shared.login(email: email, password: password)
                    } catch {
                        errorText = error.localizedDescription
                        errorToggle = true
                    }
                }
            }
        }
        .padding()
        .alert(errorText, isPresented: $errorToggle) {}
    }
}

#Preview {
    ProfileView()
}
