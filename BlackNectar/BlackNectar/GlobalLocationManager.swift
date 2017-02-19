//
//  GlobalLocationManager.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import MapKit
import UIKit


class UserLocation: NSObject, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    static let instance = UserLocation()
    private override init() {}
    
    private var alreadyInitialized = false
    private var onLocation: ((CLLocationCoordinate2D) -> Void)?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var currentRegion: MKCoordinateRegion?
    
    var currentCoordinate: CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    func initialize() {
        
        if alreadyInitialized {
            
            LOG.info("Location Manager already initialized")
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
            
            makeNoteThatFailedToGetLocation()
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
        
        switch status {
            
            case .restricted:
                makeNoteThatAccessIsRestricted()
                
            case .denied:
                makeNoteThatAccessIsDenied()
                
            case .authorizedWhenInUse, .authorizedAlways:
                makeNoteThatAccessGranted(status)
                
            default:
                makeNoteThatAccessIsUndetermined()
            
        }
        
    }
    
    internal func calculateRegion(for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
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


fileprivate extension UserLocation {
    
    func makeNoteThatFailedToGetLocation() {
        
        LOG.error("Failed to load the user's location")
        
        AromaClient.beginMessage(withTitle: "Failed To Load Location")
            .addBody("Failed to load the user's location")
            .withPriority(.high)
            .send()
    }
    
    func makeNoteThatAccessIsRestricted() {
        
        LOG.warn("User restricted access to Location")
        
        AromaClient.beginMessage(withTitle: "User Location Access Restricted")
            .addBody("The User has restricted access to their locaiton")
            .withPriority(.high)
            .send()
    }
    
    func makeNoteThatAccessIsDenied() {
        
        LOG.warn("User denied access to location")
        
        AromaClient.beginMessage(withTitle: "User Location Access Denied")
            .addBody("User denied permission to access their location")
            .withPriority(.medium)
            .send()
    }
    
    func makeNoteThatAccessGranted(_ status: CLAuthorizationStatus) {
        
        LOG.warn("User allowed access to location: \(status.name)")
        
        AromaClient.beginMessage(withTitle: "User Location Access Granted")
            .addBody("User granted authorization to use their location: \(status)")
            .withPriority(.low)
            .send()
    }
    
    func makeNoteThatAccessIsUndetermined() {
        
        LOG.warn("User status not determined")
        
        AromaClient.beginMessage(withTitle: "User Location Access Undetermined")
            .addBody("The user has not yet made a choice regarding whether this app can use location services")
            .withPriority(.medium)
            .send()
    }
    
}

fileprivate extension CLAuthorizationStatus {
    
    var name: String {
        
        switch self {
            case .authorizedAlways : return "(authorizedAlways)"
            case .authorizedWhenInUse : return "(authorizedWhenInUse)"
            case .denied : return "(denied)"
            case .notDetermined : return "(notDetermined)"
            case .restricted : return "(restricted)"
        }
    }
}
