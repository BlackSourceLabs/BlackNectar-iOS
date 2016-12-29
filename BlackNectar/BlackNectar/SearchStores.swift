//
//  SearchStores.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SearchStores {
    
    typealias Callback = ([StoresInfo]) -> ()
    
    // API Call
    static func searchForStoresLocations(near point: CLLocationCoordinate2D, callback: @escaping Callback) {
        
        let storesAPI = "https://blacknectar-api.sirwellington.tech:9102/stores?latitude=\(point.latitude)&longitude=\(point.longitude)&radius=3000"
        let url = URL(string: storesAPI)!
        
        getStoresFrom(url: url, callback: callback)
        
    }
    
    static func searchForStoresByName(withName name: String, callback: Callback) {
        
        //Make API call to get stores with searchTerm `name`
        let stores = [StoresInfo]()
        
        callback(stores)
    }
    
    private static func getStoresFrom(url: URL, callback: @escaping Callback) {
        //Get stores from url
        //When done, pass them to `callback`
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error  in
            
            //If I have data, parse the stores from it
            if error != nil {
                print("Failed to download stores from: \(url)")
                return
            }
            
            guard let data = data else {
                print("Could not load stores from: \(url)")
                return
            }
            
            let stores: [StoresInfo] = parseStores(from: data)
            
            //We have contact. Here are the stores
            callback(stores)
            
            
        }
        
        task.resume()
        
    }
    
    
    private static func parseStores(from data: Data) -> [StoresInfo] {
        
        var storesArray: [StoresInfo] = []
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonArray = json as? NSArray else {
              return storesArray
        }
        
        for element in jsonArray {
            guard let object = element as? NSDictionary else {
            continue
            }
            
            guard let store = StoresInfo.fromJson(dictionary: object) else { continue }
            
            storesArray.append(store)
            
        }
        
        return storesArray
        
    }
    
}


