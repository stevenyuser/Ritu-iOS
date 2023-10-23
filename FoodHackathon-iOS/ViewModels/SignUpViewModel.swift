//
//  SignUpViewModel.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation
import Combine
import FirebaseAuth
//import Resolver
import FirebaseFirestore
import FirebaseFirestoreSwift

class SignUpViewModel: ObservableObject {
    @Published private var authManager: FirebaseAuthenticationManager = Resolver.resolve()
    private let locationManager = LocationManager()
    private let db = Firestore.firestore()

    
    @Published var errorMessage: String?
    @Published var hasError: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    private func addSubscribers() {
        
        authManager.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
                
                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        // waits 5 seconds after errorMessage is changed to erase the errorMessage
        $errorMessage
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.errorMessage = nil
                self.hasError = false
            }
            .store(in: &cancellables)
        
    }
    
    func signUp(creds: AppCredentialsDetails, details: UserModel) async {
        do {
            
            // signing up user with FBAuth
            authManager.removeStateListener()
            let authDataResult = try await Auth.auth().createUser(withEmail: creds.email, password: creds.password)
            
            //
            var finalUserDetails = details
            finalUserDetails.userId = authDataResult.user.uid
            
            let newDocReference = try db.collection("users").document(finalUserDetails.userId).setData(from: finalUserDetails)
            print("User stored with new document reference: \(newDocReference)")

            authManager.registerStateListener()
        } catch {
            print("There was an issue when trying to sign up: \(error)")
            DispatchQueue.main.async {
                self.authManager.reinstallStateListener()
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
        
    }
    
    
}
