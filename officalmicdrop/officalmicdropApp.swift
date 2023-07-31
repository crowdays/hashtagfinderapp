//
//  officalmicdropApp.swift
//  officalmicdrop
//
//  Created by Leo Juarez on 5/23/23.
//

import SwiftUI
import Firebase

@main
struct officalmicdropApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var ratingManager = RatingManager() // 1. Create an instance of RatingManager

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(viewModel)
            .environmentObject(ratingManager) // 2. Add it to the environment
        }
    }
}
