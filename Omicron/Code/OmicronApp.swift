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
    
    @StateObject private var accountManager: AccountManager = { ProcessInfo.processInfo.arguments.contains("--testing") ? .init(true) : .init() }()
    @StateObject private var theme: ThemeManager = .init()
    
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(accountManager)
        .environmentObject(theme)
    }
}
