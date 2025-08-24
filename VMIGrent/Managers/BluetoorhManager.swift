//
//  BluetoorhManager.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 12.01.2023.
//

import Foundation

class BluetoorhManager: NSObject {
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    static let shared = VRLocationManager()
    
    private override init() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.location = locValue
    }
    
}
