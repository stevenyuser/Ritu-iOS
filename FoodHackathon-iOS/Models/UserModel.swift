//
//  UserModel.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var displayName: String
    var phoneNumber: String
    var crops: [Crop]
    var position: GeoPoint
    
    var collectiveName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        case phoneNumber = "phone_number"
        case crops
        case position
        case collectiveName = "collective_name"
    }
}
