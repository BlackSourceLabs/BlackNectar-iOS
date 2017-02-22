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
        guard let url = URL(string: storesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
        
    }
    
    static func searchForStoresByZipCode(withZipCode zipCode: String, callback: @escaping Callback) {
        
        let storesAPI = "https://blacknectar-api.blacksource.tech:9102/stores?zipCode=\(zipCode)"
        guard let url = URL(string: storesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
        
    }
    
    static func searchForStoresByName(withName name: String, callback: @escaping Callback) {
        
        let storesAPI = "https://blacknectar-api.blacksource.tech:9102/stores?searchTerm=\(name)"
        guard let url = URL(string: storesAPI) else {
            callback([])
            return
        }
        
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
                
                noteThatFailedToDownloadStores(from: url, error: error)
                return
                
            }
            
            guard let data = data else {
                
                noteThatFailedToDownloadStores(from: url, error: error)
                return
                
            }
            
            let stores: [Store] = parseStores(from: data)
            
            //We have contact. Here are the stores
            callback(stores)
            makeNoteThatStoresLoaded(stores: stores, using: url)
            
            let time = abs(now.timeIntervalSinceNow)
            
            if time > 3.0 {
                
                noteThatLoadingStoreTookLongerThan3Seconds(time: time)
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
            
            guard let store = Store.getStoreJsonData(from: object) else {
                makeNoteThatStoreCouldNotBeParsed(json: object)
                continue
            }
            
            storesArray.append(store)
            
        }
        
        return storesArray
        
    }
    
}

//MARK: Aroma Messages
fileprivate extension SearchStores {
    
    static func noteThatFailedToDownloadStores(from url: URL, error: Error? = nil) {
        
        LOG.error("Failed to download stores from: \(url) | \(error)")
        
        AromaClient.beginMessage(withTitle: "Failed to download stores from url")
            .addBody("Failed to download stores from: \(url)").addLine(2)
            .addBody("\(error)")
            .withPriority(.high)
            .send()
    }
    
    static func noteThatLoadingStoreTookLongerThan3Seconds(time: TimeInterval) {
        
        LOG.warn("Loading stores took longer than 3 seconds: \(time)s")
        
        AromaClient.beginMessage(withTitle: "High Latency Loading Stores")
            .addBody("Loading stores took \(time)s long")
            .withPriority(.medium)
            .send()
    }
    
    static func makeNoteThatStoresLoaded(stores: [Store], using url: URL) {
        
        let message =  "Loaded \(stores.count) stores using URL | \(url)"
        LOG.debug(message)
        
        AromaClient.beginMessage(withTitle: "Stores Loaded")
            .addBody(message)
            .withPriority(.low)
            .send()
    }
    
    static func makeNoteThatStoreCouldNotBeParsed(json: NSDictionary) {
        
        let message = "Could not parse store from JSON: \(json)"
        LOG.warn(message)
        
        AromaClient.beginMessage(withTitle: "JSON Parse Failed")
            .addBody(message)
            .withPriority(.medium)
            .send()
    }
    
}


