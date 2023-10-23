//
//  CropRecs.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import Foundation

struct CropRecs: Codable {
    let name: String
    
    let pests: [Pest]
    
    let extremeWeatherConditions: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case pests
        case extremeWeatherConditions = "extreme_weather_conditions"
    }
}

struct Pest: Codable, Hashable {
    let name: String
    let riskLevel: String // high, medium, low
    
    enum CodingKeys: String, CodingKey {
        case name
        case riskLevel = "risk_level"
    }
}
