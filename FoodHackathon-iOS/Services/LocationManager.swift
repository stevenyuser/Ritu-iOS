//
//  LocationManager.swift
//  FoodHackathon-iOS
//
//  Created by Steven Yu on 10/21/23.
//

import Foundation
import CoreLocation
import CoreLocationUI

// location manager
// source: https://stackoverflow.com/questions/75332935/get-users-current-location-and-upload-it-to-firebase
class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    func getLocation(completion: @escaping (CLLocationCoordinate2D) -> ()) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.completion = completion
    }

    private var completion: ((CLLocationCoordinate2D) -> ())?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        locationManager.stopUpdatingLocation()
        completion?(location.coordinate)
    }
}
