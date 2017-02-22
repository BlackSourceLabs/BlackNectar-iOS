//
//  DistanceCalculation Class.swift
//  BlackNectar
//
//  Created by K on 12/29/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import CoreLocation

class DistanceCalculation {
    
    static func getDistance(userLocation: CLLocationCoordinate2D, storeLocation: CLLocationCoordinate2D) -> Double {
        
        let userCoordinate = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let storeCoordinate = CLLocation(latitude: storeLocation.latitude, longitude: storeLocation.longitude)
        
        let distanceInMeters = userCoordinate.distance(from: storeCoordinate)
        
        return distanceInMeters
    
    }
    
    static func milesToMeters(miles: Double) -> Double {
        
        let meters = miles * 1609.34
        
        return meters
        
    }
    
    static func metersToMiles(meters: Double) -> Double{
        
        let miles = meters * 0.000621371
        
        return miles
        
    }
    
}
