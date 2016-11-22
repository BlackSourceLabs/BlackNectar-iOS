//
//  StoresDataStruct.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Creating data structure for JSON Request
struct StoresInfo {
    
    let storeName: String
    let location: NSDictionary
    let address: NSDictionary
    
    static func fromJson(dictionary: NSDictionary) -> StoresInfo? {
        
        guard let storeName = dictionary ["store_name"] as? String,
            let location = dictionary ["location"] as? NSDictionary,
            let address = dictionary ["address"] as? NSDictionary else {
                print ("Guard failed on fromJson()")
                return nil
        }
        
        guard let coordinatesDictionary = dictionary ["location"] as? NSDictionary else { return nil }
            guard let latitude = coordinatesDictionary ["latitude"] as? CLLocationDegrees else { return nil }
            guard let longitude = coordinatesDictionary ["longitude"] as? CLLocationDegrees else { return nil }
            let coordinatesObject = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return StoresInfo(storeName: storeName, location: location, address: address)
        
    }

    

}

