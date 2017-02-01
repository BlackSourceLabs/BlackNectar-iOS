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

// Creates data structure for JSON Request
struct Store {
    
    let storeName: String
    let location: CLLocationCoordinate2D
    let address: Address
    let storeImage: URL
    let isFarmersMarket: Bool
    
    var notFarmersMarket: Bool { return !isFarmersMarket }
    
    
    static func getStoreJsonData(from storeDictionary: NSDictionary) -> Store? {
    
        guard let storeName = storeDictionary ["store_name"] as? String,
            let addressJSON = storeDictionary ["address"] as? NSDictionary,
            let storeType = storeDictionary ["main_image_url"] as? String,
            let storeImage = URL(string: storeType)

            else {
                
                LOG.error("Failed on getting Store JSON Data")
                return nil
                
        }
        
        guard let address = Address(from: addressJSON) else { return nil }
        
        guard let coordinatesDictionary = storeDictionary ["location"] as? NSDictionary else { return nil }
        guard let latitude = coordinatesDictionary ["latitude"] as? CLLocationDegrees else { return nil }
        guard let longitude = coordinatesDictionary ["longitude"] as? CLLocationDegrees else { return nil }
        let coordinatesObject = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let isFarmersMarket: Bool = storeDictionary["is_farmers_market"] as? Bool ?? false
        
        return Store(storeName: storeName, location: coordinatesObject, address: address, storeImage: storeImage, isFarmersMarket: isFarmersMarket)
        
    }
    
}

struct Address {
    
    let addressLineOne: String
    let addressLineTwo: String?
    let city: String
    let state: String
    let county: String
    let zipCode: String
    let localZipCode: String?
    
    init?(from storeDictionary: NSDictionary) {
        
        guard let addressLineOne = storeDictionary ["address_line_1"] as? String else { return nil }
        
        let addressLineTwo = storeDictionary ["address_line_2"] as? String
        
        guard let city = storeDictionary ["city"] as? String else { return nil }
        guard let state = storeDictionary ["state"] as? String else { return nil }
        guard let county = storeDictionary ["county"] as? String else { return nil }
        guard let zipCode = storeDictionary ["zip_code"] as? String else { return nil }
        
        let localZipCode = storeDictionary ["local_zip_code"] as? String
        
        self.addressLineOne = addressLineOne
        self.addressLineTwo = addressLineTwo
        
        self.city = city
        self.state = state
        self.county = county
        self.zipCode = zipCode
        self.localZipCode = localZipCode
    }
    
}

