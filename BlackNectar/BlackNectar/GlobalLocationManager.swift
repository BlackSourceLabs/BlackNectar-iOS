//
//  GlobalLocationManager.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

//TODO: Make this class a Singleton
class UserLocation: NSObject, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    static let singleInstance = UserLocation()
    private override init() {}
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?
    
    func prepareLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation: CLLocation = locations.first else {
            return
        }
        
        defer {
            locationManager.stopUpdatingLocation()
        }
        
        currentLocation = userLocation.coordinate
        
    }
    
    func calculateRegion(for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
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
