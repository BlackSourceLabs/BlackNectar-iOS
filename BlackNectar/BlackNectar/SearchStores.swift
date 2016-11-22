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
    
//    typealias Stores = [StoresInfo]
    typealias Callback = ([StoresInfo]) -> ()
    
    // API Call
    static func searchForStoresLocations(near point: CLLocationCoordinate2D, callback: @escaping Callback) {
        
        print("point is : \(point)")
        
        let storesAPI = "http://blacknectar-api.sirwellington.tech:9100/stores?lat=\(point.latitude)&lon=\(point.longitude)"
        
        let url = URL(string: storesAPI)!
        
        getStoresFrom(url: url, callback: callback)

    }

    static func searchForStores(withName name: String, callback: Callback) {
        
        //Make API call to get stores with searchTerm `name`
        let stores = [StoresInfo]()
        
        callback(stores)
    }
    
    static func storesApiCall(near location: CLLocationCoordinate2D, callback: @escaping Callback) {
        
        let storesAPI = "http://blacknectar-api.sirwellington.tech:9100/stores?lat=lon=&limit=20"
        let url = URL(string: storesAPI)!
        let request = URLRequest.init(url: url)
        let stores = [StoresInfo]()
        
        callback(stores)
        
    }
    
    
    private static func getStoresFrom(url: URL, callback: @escaping Callback) {
        //Get stores from url
        //When done, pass them to `callback`
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error  in
            
            print("data task data is : \(data) & response is : \(response)")
            
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
        StoresMapViewController().populateStoreAnnotations()
    }
    
    private static func parseStores(from data: Data) -> [StoresInfo] {
        
        var storesArray: [StoresInfo] = []
    
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
      
        for i in jsonObject! {
            
            let dict = i as? NSDictionary
            let storeDictionary = StoresInfo.fromJson(dictionary: dict!)
            
            storesArray.append(storeDictionary!)
            
        }
        
        return storesArray
        
    }
}


