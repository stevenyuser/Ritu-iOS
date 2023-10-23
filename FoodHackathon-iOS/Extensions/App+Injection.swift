//
//  App+Injection.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation
//import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { FirebaseAuthenticationManager() }
            .scope(.application)
    }
}
