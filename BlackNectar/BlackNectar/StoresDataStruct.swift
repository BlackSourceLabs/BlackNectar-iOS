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
        
        if let storeImageString = json[Keys.storeImage] as? String  {
            
            storeImage = URL(string: storeImageString)
        }
        else {
            
            self.storeImage = nil
        }
        
        guard let storeID = json[Keys.storeID] as? String,
            let storeName = json[Keys.storeName] as? String,
            let addressJSON = json[Keys.address] as? NSDictionary
            else {
                
                LOG.error("Failed to parse Store: \(json)")
                return nil
        }
        
        guard let address = Address(from: addressJSON) else { return nil }
        
        guard let coordinatesDictionary = json[Keys.location] as? NSDictionary,
            let latitude = coordinatesDictionary[Keys.latitude] as? CLLocationDegrees,
            let longitude = coordinatesDictionary[Keys.longitude] as? CLLocationDegrees
            else {
                
                LOG.warn("Failed to get Store location information: \(json)")
                return nil
        }
        
        let coordinatesObject = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let isFarmersMarket: Bool = json[Keys.isFarmersMarket] as? Bool ?? false
        
        self.storeID = storeID
        self.storeName = storeName
        self.address = address
        self.location = coordinatesObject
        self.isFarmersMarket = isFarmersMarket
        
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
        
        guard let addressLineOne = storeDictionary[Keys.addressLineOne] as? String else { return nil }
        let addressLineTwo = storeDictionary[Keys.addressLineTwo] as? String
        
        guard let city = storeDictionary[Keys.city] as? String else { return nil }
        guard let state = storeDictionary[Keys.state] as? String else { return nil }
        guard let county = storeDictionary[Keys.county] as? String else { return nil }
        guard let zipCode = storeDictionary[Keys.zipCode] as? String else { return nil }
        let localZipCode = storeDictionary[Keys.localZipCode] as? String
        
        self.addressLineOne = addressLineOne
        self.addressLineTwo = addressLineTwo
        self.city = city
        self.state = state
        self.county = county
        self.zipCode = zipCode
        self.localZipCode = localZipCode
        
    }
    
}
