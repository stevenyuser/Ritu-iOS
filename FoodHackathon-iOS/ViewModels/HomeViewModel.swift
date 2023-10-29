//
//  HomeViewModel.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import Foundation
import Combine
//import Resolver
import Alamofire

class HomeViewModel: ObservableObject {
    @Published private var authManager: FirebaseAuthenticationManager = Resolver.resolve()
    @Published var userModel: UserModel?
    
    @Published var gotData: Bool = false
    @Published var cropRecs: CropRecs = CropRecs(name: "", pests: [], extremeWeatherConditions: "")
    
    let baseURL: String = "https://goldfish-app-o3qh7.ondigitalocean.app"

    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        // get user model
        authManager.$userModel
            .sink { [weak self] (returnedUserModel) in
                self?.userModel = returnedUserModel
            }
            .store(in: &cancellables)
        
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
    
    // TODO - do
    // get crop recs from api
    func getCropRecs() {
        print("Getting crop recs..")
        gotData = false
        
        guard let phoneNumber = userModel?.phoneNumber else {
            print("No phone number")
            return
        }
        
        let parameters: [String: String] = [
            "phone_number": phoneNumber,
            "user_id": userModel?.userId ?? "bruh" // optional, might not be used
        ]
        
        AF.request(baseURL + "/get_crop_recs", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: GetCropRecsResponse.self) { response in
                debugPrint("response: \(response.description)")
                self.cropRecs = response.value?.cropRecs ?? CropRecs(name: "", pests: [], extremeWeatherConditions: "")
                self.gotData = true
            }
    }
    
    func getDummyCropRecs() {
        let dummyPests: [Pest] = [Pest(name: "Stem borer", riskLevel: "Low"), Pest(name: "Leaf roller", riskLevel: "Low"), Pest(name: "Gall midge", riskLevel: "Low")]
        let dummyWeather = "None" // possible other: heat wave
        let dummyData: CropRecs = CropRecs(name: "Rice", pests: dummyPests, extremeWeatherConditions: dummyWeather)
        
        cropRecs = dummyData
        gotData = true
    }
    
    func sendSMS() {
        guard let phoneNumber = userModel?.phoneNumber else {
            print("No phone number")
            return
        }
        
        let parameters: [String: String] = [
            "phone_number": phoneNumber
        ]
        
        AF.request(baseURL + "/send_sms", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: SendSMSResponse.self) { response in
                debugPrint("response: \(response.description)")
            }
        
    }
    
}
