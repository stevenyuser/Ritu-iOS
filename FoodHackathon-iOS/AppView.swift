//
//  AppView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI
//import Resolver

struct AppView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    AppView()
}
