//
//  LandingView.swift
//  Omicron
//
//  Created by Beni Kis on 16/05/2024.
//

import SwiftUI

struct LandingView: View {
    @State private var pictures: [String] = ["https://artworks.thetvdb.com/banners/posters/328724-2.jpg", "https://artworks.thetvdb.com/banners/posters/78804-52.jpg"]
    
    @ObservedObject private var auth = AuthStore()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.offWhite
                    .ignoresSafeArea()
                VStack {
                    Label("Welcome to Omicron!", systemImage: "hand.wave")
                        .bold()
                    TabView {
                        ForEach($pictures, id: \.self) {
                            ShowImageCard(url: $0)
                                .shadow(radius: 5)
                                .padding()
                        }
                    }
                    .frame(height: 400)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    VStack {
                        HStack(spacing: 30) {
                            NavigationLink {
                                
                            } label: {
                                Text("Register")
                            }
                            .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15), width: 90))
                            NavigationLink {
                                LoginView()
                            } label: {
                                Text("Login")
                            }
                            .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15), width: 90))
                        }
                        .padding(.vertical)
                        Button("Maybe later") {
                            auth.data.cancelledLogin = true
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .shadow(radius: 5)
                    }
                }
                .toolbarBackground(Color.offWhite, for: .navigationBar)
            }
        }
    }
}

#Preview {
    LandingView()
}
