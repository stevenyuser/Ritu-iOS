//
//  CropTile.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import SwiftUI

struct CropTile: View {
    var cropName: String
    var checked: Bool
    
    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 30))
                .padding(.leading, 5)
            
            Spacer()
            Spacer()
            
            Text(cropName)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
        }
        .appButtonStyle()
    }
}
