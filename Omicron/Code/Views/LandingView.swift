//
//  LandingView.swift
//  Omicron
//
//  Created by Beni Kis on 16/05/2024.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var accountManager: AccountManager
    
    private let pictures = [
        "https://artworks.thetvdb.com/banners/posters/328724-2.jpg",
        "https://artworks.thetvdb.com/banners/posters/78804-52.jpg"
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.selected.primary.ignoresSafeArea()
                
                VStack {
                    WelcomeHeader
                    ImageCarousel
                    ActionButtons
                }
                .toolbarBackground(theme.selected.primary, for: .navigationBar)
            }
        }
    }
    
    private var WelcomeHeader: some View {
        Label("Welcome to Omicron!", systemImage: "hand.wave")
            .bold()
    }
    
    private var ImageCarousel: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<pictures.count, id: \.self) { index in
                CachedAsyncImage(url: URL(string: pictures[index])!) {
                    $0.resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        .padding()
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 400)
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % pictures.count
            }
        }
    }
    
    private var ActionButtons: some View {
        VStack {
            HStack(spacing: 30) {
                NavigationLink {
                    LoginRegisterView(isSignup: true)
                } label: {
                    Text("Register")
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15), width: 90))
                .accessibilityIdentifier("Register")
                NavigationLink {
                    LoginRegisterView(isSignup: false)
                } label: {
                    Text("Login")
                }
                .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15), width: 90))
                .accessibilityIdentifier("Login")
            }
            .padding(.vertical)
            
            Button("Maybe later") {
                accountManager.currentAccount = accountManager.offlineAccount
            }
            .buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 15), width: 90, color: theme.selected.secondary))
            .accessibilityIdentifier("DismissLogin")
        }
    }
}

#Preview {
    LandingView()
        .modelContainer(for: ShowModel.self, inMemory: true)
        .environmentObject(ThemeManager())
        .environmentObject(AccountManager())
}
