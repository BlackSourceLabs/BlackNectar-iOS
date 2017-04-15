//
//  StoresDataStruct.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation
import UIKit

// Creates data structure for JSON Request
struct Store {
    
    let storeID: String
    let storeName: String
    let location: CLLocationCoordinate2D
    let address: Address
    let storeImage: URL?
    let isFarmersMarket: Bool
    
    var notFarmersMarket: Bool { return !isFarmersMarket }
    
    static func getStoreJsonData(from storeDictionary: NSDictionary) -> Store? {
        
        return Store(json: storeDictionary)
    }
    
}

extension Store {
    
    init?(json: NSDictionary) {
        
        if let storeImageString = json["main_image_url"] as? String  {
            
            storeImage = URL(string: storeImageString)
        }
        else {
            
            self.storeImage = nil
        }
        
        guard let storeID = json ["store_id"] as? String,
            let storeName = json ["store_name"] as? String,
            let addressJSON = json ["address"] as? NSDictionary
            else {
                
                LOG.error("Failed to parse Store: \(json)")
                return nil
        }
        
        guard let address = Address(from: addressJSON) else { return nil }
        
        guard let coordinatesDictionary = json ["location"] as? NSDictionary,
            let latitude = coordinatesDictionary ["latitude"] as? CLLocationDegrees,
            let longitude = coordinatesDictionary ["longitude"] as? CLLocationDegrees
            else {
                
                LOG.warn("Failed to get Store location information: \(json)")
                return nil
        }
        
        let coordinatesObject = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let isFarmersMarket: Bool = json ["is_farmers_market"] as? Bool ?? false
        
        self.storeID = storeID
        self.storeName = storeName
        self.address = address
        self.location = coordinatesObject
        self.isFarmersMarket = isFarmersMarket
        self.storeImage = storeImageURL!
        
    }
    
}

extension Store : CustomStringConvertible {
    
    var description: String {
        return "{storeName: \(storeName), address: \(address), location: \(location), isFarmersMarket: \(isFarmersMarket)}"
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
    
}

extension Address {
    
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
