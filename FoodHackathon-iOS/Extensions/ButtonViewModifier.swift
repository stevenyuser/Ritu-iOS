//
//  ButtonViewModifier.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/22/23.
//

import SwiftUI

struct AppButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color("RituGreen"))
            .clipShape(.rect(cornerRadius: 16))
            .padding(.horizontal)
    }
}

extension View {
    func appButtonStyle() -> some View {
        modifier(AppButton())
    }
}
