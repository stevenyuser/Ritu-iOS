//
//  AuthenticationManager.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore

class FirebaseAuthenticationManager: ObservableObject {
    @Published var userModel: UserModel?
    @Published var isAuthenticated: Bool = UserDefaults.standard.bool(forKey: "authenticated")
    
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    private let path: String = "users"
    private let db = Firestore.firestore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("Authentication Manager initialized")
        print(isAuthenticated)
        addSubscribers()
        registerStateListener()
    }
    
    deinit {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    private func addSubscribers() {
        
        // waits 5 seconds after errorMessage is changed to erase the errorMessage
        $errorMessage
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.errorMessage = nil
                self.hasError = false
            }
            .store(in: &cancellables)
        
    }
    
    // source: https://peterfriese.dev/posts/replicating-reminder-swiftui-firebase-part2/
    // listens for user session (checks if user is signed in, signed out, user account is available, etc.)
    // handles all the session activities automatically, other functions should not handle isAuthenticated and user
    // source: https://firebase.google.com/docs/auth/ios/start
    func registerStateListener() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.db.collection(self.path)
                    .document(user.uid)
                    .getDocument(as: UserModel.self) { result in
                        switch result {
                        case .success(let userModel):
                            self.userModel = userModel
                            withAnimation(.easeInOut) {
                                self.isAuthenticated = true
                                UserDefaults.standard.set(true, forKey: "authenticated")
                            }
                        case .failure(let error):
                            self.userModel = nil
                            withAnimation(.easeInOut) {
                                self.isAuthenticated = false
                                UserDefaults.standard.set(false, forKey: "authenticated")
                            }
                            self.errorMessage = "Couldn't get user document from Firestore: \(error)"
                            self.hasError = true
                        }
                    }
            } else {
                self.userModel = nil
                withAnimation(.easeInOut) {
                    self.isAuthenticated = false
                    UserDefaults.standard.set(false, forKey: "authenticated")
                }
                print("User N/A")
            }
        }
    }
    
    func reinstallStateListener() {
        registerStateListener()
    }
    
    func removeStateListener() {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @MainActor
    func signIn(creds: AppCredentialsDetails) async {
        do {
            try await Auth.auth().signIn(withEmail: creds.email, password: creds.password)
            
            // show linking page every time a user signs in
            UserDefaults.standard.set(true, forKey: "show_linking")
        }
        catch {
            print("There was an issue when trying to sign in: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
    }
    
    @MainActor
    func signOut() async {
        do {
            try Auth.auth().signOut()
            
            // clear user defaults
            UserDefaults.standard.removeObject(forKey: "e_username")
            UserDefaults.standard.removeObject(forKey: "e_password")
            UserDefaults.standard.removeObject(forKey: "public_key")
            UserDefaults.standard.removeObject(forKey: "show_linking")
            UserDefaults.standard.set(false, forKey: "authenticated")
            print("Signed out")
        } catch {
            print("There was an issue when trying to sign out: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
    }
    
//    @MainActor
//    func signUp(creds: AppCredentialsDetails, userDetails: UserModel) async {
//        do {
//            let authDataResult = try await Auth.auth().createUser(withEmail: creds.email, password: creds.password)
//
//            var finalUserDetails = userDetails
//            finalUserDetails.email = creds.email
//            finalUserDetails.userId = authDataResult.user.uid
//
//            try db.collection(path).document(authDataResult.user.uid).setData(from: finalUserDetails)
//
//            // show linking page every time a user signs up
//            UserDefaults.standard.set(true, forKey: "show_linking")
//        } catch {
//            print("There was an issue when trying to sign up: \(error)")
//            DispatchQueue.main.async {
//                self.errorMessage = error.localizedDescription
//                self.hasError = true
//            }
//        }
//    }
    
//    func finishSignUp() {
//        registerStateListener()
//        UserDefaults.standard.set(true, forKey: "show_linking")
//    }
    
//    func deleteUser() {
//        if let user = Auth.auth().currentUser {
//            // delete user doc
//            self.db.collection(self.path)
//                .document(user.uid)
//                .delete { error in
//                    if let error = error {
//                        self.errorMessage = error.localizedDescription
//                        self.hasError = true
//                    }
//                    // delete user
//                    user.delete { error in
//                        if let error {
//                            print("Could not delete user")
//                            DispatchQueue.main.async {
//                                self.errorMessage = error.localizedDescription
//                                self.hasError = true
//                            }
//                        }
//
//                        // clear user defaults
//                        UserDefaults.standard.removeObject(forKey: "e_username")
//                        UserDefaults.standard.removeObject(forKey: "e_password")
//                        UserDefaults.standard.removeObject(forKey: "public_key")
//                        UserDefaults.standard.removeObject(forKey: "show_linking")
//                        UserDefaults.standard.set(false, forKey: "authenticated")
//                        print("Delete account")
//                    }
//                }
//        }
//    }
        
    @MainActor
    func sendPasswordReset(email: String? = nil) {
        if let email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error {
                    self.errorMessage = "Couldn't send password reset: \(error.localizedDescription)"
                    self.hasError = true
                }
            }
        } else if let email = Auth.auth().currentUser?.email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error {
                    self.errorMessage = "Couldn't send password reset: \(error.localizedDescription)"
                    self.hasError = true
                }
            }
        }
    }
}
