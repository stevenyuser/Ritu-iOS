//
//  RouterView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI
//import Resolver

struct RouterView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
//    @StateObject var api: APIService
    
    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                AppView()
                    .transition(.move(edge: .bottom))
            } else {
                AuthenticationView()
                    .environmentObject(authManager)
            }
        }
    }
}
