//
//  OmicronApp.swift
//  Omicron
//
//  Created by Beni Kis on 22/02/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        resetState()
        FirebaseApp.configure()
        return true
    }
    
    /// Resets the persistent data of the application.
    ///
    /// Only use this method when testing!
    private func resetState() {
        if ProcessInfo.processInfo.arguments.contains("--reset-state") {
            UserDefaults.standard.removeObject(forKey: "currentAccount")
            UserDefaults.standard.removeObject(forKey: "offlineAccount")
        }
    }
}

@main
struct OmicronApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.defaultAPIController) private var apiController
    
    /// Initialize the account management, if "--testing" is present in process arguments then it uses the testing db
    @StateObject private var accountManager: AccountManager = { ProcessInfo.processInfo.arguments.contains("--testing") ? .init(true) : .init() }()
    @StateObject private var theme: ThemeManager = .init()

    @State private var isLoading = false
    @State private var hasUser = false
    
    /// SwiftData model container creation
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ShowOverviewModel.self, ShowModel.self, UserModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView()
                } else if hasUser {
                    ContentView()
                } else {
                    LandingView()
                }
            }
            .animation(.default, value: [isLoading, hasUser])
            .onChange(of: accountManager.isAuthenticating) { _, newValue in
                isLoading = newValue
            }
            .onChange(of: accountManager.currentAccount) { _, newValue in
                hasUser = newValue != nil
            }
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(accountManager)
        .environmentObject(theme)
    }
}
