//
//  Response.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import Foundation

struct SendSMSResponse: Codable {
    let message: String
}

struct GetCropRecsResponse: Codable {
    let message: String
    let cropRecs: CropRecs
    
    enum CodingKeys: String, CodingKey {
        case message
        case cropRecs = "crop_recs"
    }
}
