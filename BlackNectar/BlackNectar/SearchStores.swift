//
//  SearchStores.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import UIKit

class SearchStores {
    
    typealias Callback = ([Store]) -> ()
    
    // API Call
    static func searchForStoresLocations(near point: CLLocationCoordinate2D, callback: @escaping Callback) {
        
        let storesAPI = "https://blacknectar-api.blacksource.tech:9102/stores?latitude=\(point.latitude)&longitude=\(point.longitude)"
        guard let url = URL(string: storesAPI) else { return }
        
        getStoresFrom(url: url, callback: callback)
        
    }
    
    static func searchForStoresByName(withName name: String, callback: @escaping Callback) {
        
        let storesAPI = "https://blacknectar-api.blacksource.tech:9102/stores?searchTerm=\(name)"
        guard let url = URL(string: storesAPI) else { return }
        
        getStoresFrom(url: url, callback: callback)
        
    }
    
    static func getStoresFrom(url: URL, callback: @escaping Callback) {
        //Get stores from url
        //When done, pass them to `callback`
        
        let now = Date()
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error  in
            
            //If I have data, parse the stores from it
            if error != nil {
                
                LOG.error("Failed to download stores from: \(url)")
                AromaClient.beginMessage(withTitle: "Failed to download stores from url")
                    .addBody("Failed to download stores from: \(url)")
                    .withPriority(.high)
                    .send()
                
                return
                
            }
            
            guard let data = data else {
                
                LOG.error("Failed to load stores from: \(url)")
                AromaClient.beginMessage(withTitle: "Failed to load stores from url")
                    .addBody("Failed to load stores from: \(url)")
                    .withPriority(.high)
                    .send()
                
                return
                
            }
            
            let stores: [Store] = parseStores(from: data)
            
            //We have contact. Here are the stores
            callback(stores)
            
            let time = now.timeIntervalSinceNow
            
            if abs(time) > 3.0 {
                
                LOG.warn("Loading stores took longer than 3 seconds")
                AromaClient.beginMessage(withTitle: "Loading stores took longer than 3 seconds")
                    .addBody("Loading stores took \(abs(time)) seconds long")
                    .withPriority(.medium)
                    .send()
                
            }

        }
        
        task.resume()
        
    }
    
    
    private static func parseStores(from data: Data) -> [Store] {
        
        var storesArray: [Store] = []
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonArray = json as? NSArray else {
                
              return storesArray
                
        }
        
        for element in jsonArray {
            
            guard let object = element as? NSDictionary else {
                
                continue
                
            }
            
            guard let store = Store.getStoreJsonData(from: object) else { continue }
            
            storesArray.append(store)
            
        }
        
        return storesArray
        
    }
    
}


