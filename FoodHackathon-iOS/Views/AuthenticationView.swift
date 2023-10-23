//
//  AuthenticationView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI
//import Resolver

struct AuthenticationView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    
    @State private var showSignUp: Bool = false
    @State private var showSignIn: Bool = false
    
    var body: some View {
        VStack {
            Image("LogoColor")
                .frame(width: 300, height: 300)
                .padding(30)
            
            Button {
                showSignUp.toggle()
            } label: {
                Text("Sign Up")
                    .appButtonStyle()
            }
            
            Button {
                showSignIn.toggle()
            } label: {
                Text("Sign In")
                    .appButtonStyle()
            }
        }
        .sheet(isPresented: $showSignUp) {
            NavigationStack {
                SignUpView()
                    .navigationTitle("Sign Up")
            }
        }
        .sheet(isPresented: $showSignIn) {
            NavigationStack {
                SignInView()
                    .navigationTitle("Sign In")
            }
        }
    }
}
