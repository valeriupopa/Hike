//
//  HikeViewModel.swift
//  Hike
//
//  Created by Valeriu POPA on 9/30/18.
//  Copyright © 2018 Valeriu Popa. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class HikeViewModel: NSObject {
    @objc var altitude: String = ""
    @objc var altitudeClimbed: String = ""
    @objc var altitudeAccuracy: String = ""
    @objc var errorMessage: String?
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate let altimeter = CMAltimeter()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        startAltimiter()
    }
}

// MARK: - Location Manager delegate - implementation
extension HikeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let roundedAltitude = location.altitude.rounded(.toNearestOrAwayFromZero)
            
        altitude = "\(Int(roundedAltitude))m"
        altitudeAccuracy = "+/- \(location.verticalAccuracy)m"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

fileprivate extension HikeViewModel {
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            errorMessage = "Hike needs location permission to get the altitude based on your GPS position"
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            errorMessage = "Hike needs location permission to get the altitude based on your GPS position"
        }
    }
    
    func startAltimiter() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            errorMessage = "Altimiter isn't available"
            return
        }
        
        let backgroundQueue = OperationQueue()
        backgroundQueue.qualityOfService = .background
        
        altimeter.startRelativeAltitudeUpdates(to: backgroundQueue) { [weak self] (data, error) in
            guard let self = self else { return }
            guard let altimiterData = data else { return }
            
            DispatchQueue.main.async {
                let roundedAltitude = altimiterData.relativeAltitude.doubleValue.rounded(.toNearestOrAwayFromZero)
                self.altitudeClimbed    = "\(roundedAltitude)m"
            }
        }
    }
}
