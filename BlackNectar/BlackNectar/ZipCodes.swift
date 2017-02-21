//
//  ZipCodes.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 2/21/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import MapKit

class ZipCodes {
    
    static func locationForZipCode(zipCode: String, callback: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            
            if let error = error {
                self.makeNoteThatGeoCodingFailed(zipCode: zipCode, error: error)
            }
            
            //Pick the first placemark and center the map there.
            if let placemark = placemarks?.first, let location = placemark.location?.coordinate {
                callback(location)
                return
            }
            
            callback(nil)
        }
        
    }
}

//MARK: Aroma Messages
fileprivate extension ZipCodes {
    
    static func makeNoteThatGeoCodingFailed(zipCode: String, error: Error) {
        
        let message = "Failed to reverse-geocode ZipCode [\(zipCode)]. | \(error)"
        
        LOG.error(message)
        AromaClient.sendHighPriorityMessage(withTitle: "ZipCode Geocode Failed", withBody: message)
    }
    
}
