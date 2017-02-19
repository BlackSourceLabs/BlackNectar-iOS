//
//  Locations+.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 2/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    
    /**
        A short description of the coordinate, printed in a simple (latitude, longitude) form, without the field names.
        This form can be directly entered into Google Maps, or other mapping application.
        
        - Example: "(34.5424, -117.324011)"
    */
    var shortDescription: String {
        return "(\(self.latitude), \(self.longitude))"
    }
}


/**
    Defines the `==` operation that can be used between to Coordinate objects.
 */
func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    
    return lhs.latitude == rhs.latitude &&
           lhs.longitude == rhs.longitude
}
