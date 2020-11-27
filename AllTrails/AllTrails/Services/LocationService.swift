//
//  LocationService.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationServiceUpdateLocation(currentLocation: CLLocation)
//    func locationServiceDidFailWithError(error: Error)
}

final class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?

    fileprivate let locationManager = CLLocationManager()
    fileprivate var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func startLocationUpdates() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // TODO:
//            let error = NSError(domain: "com.AllTrails", code: 200, userInfo: <#T##[String : Any]?#>)
//            delegate?.locationServiceDidFailWithError(error: <#T##Error#>)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        self.lastLocation = location
        delegate?.locationServiceUpdateLocation(currentLocation: location)
    }
}
