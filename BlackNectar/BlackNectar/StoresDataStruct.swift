//
//  StoresDataStruct.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation
import UIKit

// Creating data structure for JSON Request
struct StoresInfo {
    
    let storeName: String
    let location: CLLocationCoordinate2D
    let address: NSDictionary
    let storeImage: URL
    let isFarmersMarket: Bool
    
    var notFarmersMarket: Bool { return !isFarmersMarket }
    
    static func fromJson(dictionary: NSDictionary) -> StoresInfo? {
        
        guard let storeName = dictionary ["store_name"] as? String,
            let location = dictionary ["location"] as? NSDictionary,
            let address = dictionary ["address"] as? NSDictionary,
            let storeType = dictionary ["main_image_url"] as? String,
            let storeImage = URL(string: storeType)

            else {
                
                LOG.error("Guard Failed on fromJson method")
                return nil
                
        }
        
        guard let coordinatesDictionary = dictionary ["location"] as? NSDictionary else { return nil }
        guard let latitude = coordinatesDictionary ["latitude"] as? CLLocationDegrees else { return nil }
        guard let longitude = coordinatesDictionary ["longitude"] as? CLLocationDegrees else { return nil }
        let coordinatesObject = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let isFarmersMarket: Bool = dictionary["is_farmers_market"] as? Bool ?? false
        
        return StoresInfo(storeName: storeName, location: coordinatesObject, address: address, storeImage: storeImage, isFarmersMarket: isFarmersMarket)
        
    }
    
}

struct AddressInfo {
    
    let street: String
    let city: String
    let state: String
    
    static func addressToString(dictionary: NSDictionary) -> AddressInfo? {
        
        guard let street = dictionary["address_line_1"] as? String,
            let city = dictionary["city"] as? String,
            let state = dictionary["state"] as? String else {
                
                LOG.error("Guard Failed on addressToString method")
                return nil
                
        }
        
        return AddressInfo(street: street, city: city, state: state)
        
    }
    
}

