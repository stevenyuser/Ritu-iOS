//
//  Crop.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation

enum Crop: String, Codable, CaseIterable, Equatable {
    case rice = "Rice"
    case wheat = "Wheat"
    case maize = "Maize"
    case millets = "Millets"
    case pulses = "Pulses"
}
