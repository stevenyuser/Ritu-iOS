//
//  SignUpView.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SignUpView: View {
    @ObservedObject var vm: SignUpViewModel = SignUpViewModel()
    
    @State var gotLocation: Bool = false
    
    private let locationManager = LocationManager()
    
    @State var appCreds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")
    @State var details: UserModel = UserModel(userId: "", displayName: "", phoneNumber: "", crops: [], position: GeoPoint(latitude:0,longitude:0), collectiveName: "")
    
    var body: some View {
        Form {
            Section {
                TextField("Enter FPO name", text: $details.collectiveName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)
            } header: {
                Text("Farmer Producer Organization")
            }
            
            // basic login info (for firebase)
            Section {
                TextField("Enter email", text: $appCreds.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                SecureField("Enter password", text: $appCreds.password)
                
                TextField("Enter name", text: $details.displayName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)
                
                TextField("Enter phone number", text: $details.phoneNumber)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.phonePad)
            } header: {
                Text("Account Info")
            }
            
            Section {
                VStack {
                    ForEach(Crop.allCases, id: \.rawValue) { item in
                        CropTile(cropName: item.rawValue, checked: details.crops.contains { crop in
                            return crop.rawValue == item.rawValue
                        })
                        .onTapGesture {
                            details.crops.append(item)
                        }
                    }
                }
            } header: {
                Text("Select your crops")
            }
            
            Section {
                
                Button {
                    print("RUN THING")
                    
                    // note: bad code, violates MVVM pattern, should not do this in real project...
                    locationManager.getLocation { location in
                        print("thing: \(location.latitude)") // testing to see accurate lat
                        
                        details.position = GeoPoint(latitude: location.latitude, longitude: location.longitude)
                        
                        print(details.position)
                    }
                    
                    gotLocation = true
                } label: {
                    Text("Get Location")
                        .appButtonStyle()
                }
            } header: {
                Text("Access Location")
            }
            
            Section {
                Button {
                    Task {
                        await vm.signUp(creds: appCreds, details: details)
                    }
                } label: {
                    Text("Join Ritu!")
                        .appButtonStyle()
                }
                .opacity(gotLocation ? 1 : 0.25)
                .disabled(!gotLocation)
            } header: {
                Text("Complete Registration")
            }
        }
    }
}


