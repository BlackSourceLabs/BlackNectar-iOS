//
//  GlobalLocationManager.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import UIKit


class UserLocation: NSObject, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    static let instance = UserLocation()
    private override init() {}
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    var currentCoordinate: CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    var currentRegion: MKCoordinateRegion?
    
    private var alreadyInitialized = false
    
    private var onLocation: ((CLLocationCoordinate2D) -> Void)?
    
    func initialize() {
        
        if alreadyInitialized {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        alreadyInitialized = true
    }
    
    func requestLocation(callback: @escaping ((CLLocationCoordinate2D) -> Void)) {
         self.onLocation = callback
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = locations.first else {
            return
        }
        
        defer {
            locationManager.stopUpdatingLocation()
        }
        
        self.currentLocation = location
        let region = calculateRegion(for: location.coordinate)
        self.currentRegion = region
        
        onLocation?(location.coordinate)
        onLocation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        var allowAuthorization = false
        var locationStatus: String
        
        switch status {
            
            case CLAuthorizationStatus.restricted:
                locationStatus = "Restricted Access to Location"
                
            case CLAuthorizationStatus.denied:
                locationStatus = "User denied access to location"
                
            case CLAuthorizationStatus.notDetermined:
                locationStatus = "Status not determined"
                
            default:
                locationStatus = "Location Access Granted"
                
                allowAuthorization = true
        }
        
    }
    
    private func calculateRegion(for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
        let latitude = location.latitude
        let longitude = location.longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        return region
        
    }
    
}
