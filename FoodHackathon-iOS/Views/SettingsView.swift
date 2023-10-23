//
//  SettingsView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import SwiftUI
//import Resolver

struct SettingsView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager

    var body: some View {
        Form {
            
            Section {
                Text(authManager.userModel?.collectiveName ?? "No collective name")
            } header: {
                Text("Farmer Producer Organization")
            }
            
            Section {
                Text(authManager.userModel?.displayName ?? "No name")
            } header: {
                Text("Name")
            }
            
            Section {
                Text(authManager.userModel?.phoneNumber ?? "+12223334444")
            } header: {
                Text("Phone Number")
            }
            
            Section {
                Text(authManager.userModel?.position.description ?? "44,-70")
            } header: {
                Text("Coordinates")
            }
            
            Section {
                Button {
                    Task {
                        await authManager.signOut()
                    }
                } label: {
                    Text("Sign Out")
                }
            } header: {
                Text("Account")
            }
        }
    }
}

#Preview {
    SettingsView()
}
