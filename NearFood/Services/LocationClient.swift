//
//  LocationClient.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import SwiftUI
import CoreLocation

class LocationClient: NSObject, ObservableObject {
    
    private var locationManager: CLLocationManager?
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    @Published var log: String = ""
    
    private var lastLocation: CLLocation?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationClient: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            manager.requestLocation()
            log = "Location authorization always granted"
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            log = "Location authorization when in use granted"
        @unknown default:
            log = "Unknown authorization status"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        log = "Location updated: \(newLocation)"
        
        // Check if lastLocation is nil or if the distance is greater than 20 meters
        if let lastLocation = lastLocation {
            let distance = newLocation.distance(from: lastLocation)
            if distance < 20 {
                return // Ignore updates if the distance is less than 20 meters
            }
        }
        
        lastLocation = newLocation
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
    }
}
