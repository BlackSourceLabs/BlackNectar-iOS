//
//  UserDefaults.swift
//  BlackNectar
//
//  Created by Kevin Bradbury on 1/18/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation


class UserPreferences {
    
    static let instance = UserPreferences()
    private init() {}
    
    let defaultPreferences = UserDefaults.standard
    
    var distanceFilter: Double {
        
        get {
            
            return defaultPreferences.double(forKey: Keys.searchRadius)
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: Keys.searchRadius)
            
        }
        
    }
    
    var showFarmersMarkets: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: Keys.showFarmersMarkets) as? Bool ?? false
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: Keys.showFarmersMarkets)
            
        }
        
    }
    
    var showStores: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: Keys.showStores) as? Bool ?? false
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: Keys.showStores)
            
        }
        
    }
    
    var useMyLocation: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: Keys.useMyLocation) as? Bool ?? false
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: Keys.useMyLocation)
            
        }
        
    }
    
    var useZipCode: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: Keys.useZipCode) as? Bool ?? false
            
        }
        
        set(value) {
            
            defaultPreferences.set(value, forKey: Keys.useZipCode)
            
        }
        
    }
    
    var zipCode: String? {
        
        get {
            return defaultPreferences.object(forKey: Keys.zipCode) as? String
        }
        
        set(value) {
            
            defaultPreferences.set(value, forKey: Keys.zipCode)
            
        }
    }
    
    var isFirstTimeUser: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: Keys.isFirstTimeUser) as? Bool ?? true
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: Keys.isFirstTimeUser)
            
        }
        
    }
    
    fileprivate class Keys {
        
        private static let namespace = "tech.blacksource.blacknectar"
        
        static let searchRadius = namespace + "searchRadius"
        static let showStores = namespace + "showStores"
        static let showFarmersMarkets = namespace + "showFarmersMarkets"
        static let useMyLocation = namespace + "useMyLocation"
        static let useZipCode = namespace + "useZipCode"
        static let zipCode = namespace + "zipCode"
        static let isFirstTimeUser = namespace + "isFirstTimeUser"
    }
    
}
