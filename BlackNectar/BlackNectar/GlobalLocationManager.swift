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
    
    //THis class should not be storing "Stores" 
    //It has nothing to do with User's Location
    //Context is key
    var stores: [StoresInfo] = []
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?
    
     func prepareForLocation() -> CLLocationCoordinate2D {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location?.coordinate
       print("currentlocation equals = \(currentLocation)")
        
        return currentLocation!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation: CLLocation = locations.first else {
            return
        }
        
        defer {
            locationManager.stopUpdatingLocation()
        }
        
        currentLocation = userLocation.coordinate
        
        func calculateRegion(for location: CLLocation) -> MKCoordinateRegion {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.05
            let longDelta: CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            return region
            
        }
        
        let region = calculateRegion(for: userLocation)

        //Why would a Location Manger fetch stores? makes no sense.
        SearchStores.searchForStoresLocations(near: currentLocation!) { stores in
            self.stores = stores
            
        }


    }
    
    
}
