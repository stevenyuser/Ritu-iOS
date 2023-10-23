//
//  SignInView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm: SignInViewModel = SignInViewModel()

    @State var appCreds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")

    var body: some View {
        Form {
            
            // basic login info (for firebase)
            Section {
                TextField("Enter email", text: $appCreds.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                SecureField("Enter password", text: $appCreds.password)
            } header: {
                Text("Credentials")
            }
            
            Section {
                Button {
                    Task {
                        await vm.signIn(creds: appCreds)
                    }
                } label: {
                    Text("Sign In")
                        .appButtonStyle()
                }
            } header: {
                Text("Sign In")
            }
            
        }
    }
}
