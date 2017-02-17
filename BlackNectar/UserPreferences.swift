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
        
            return defaultPreferences.double(forKey: "distanceFilter")
        
        }
        
        set (value){
        
            defaultPreferences.set(value, forKey: "distanceFilter")
            
        }
        
    }
    
    var showFarmersMarkets: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: "showFarmersMarkets") as? Bool ?? true
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "showFarmersMarkets")
            
        }
        
    }
    
    var showStores: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: "showStores") as? Bool ?? true
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "showStores")
            
        }
        
    }
    
    var showMyLocationSwitch: Bool {
        
        get {
            
            return defaultPreferences.bool(forKey: "showMyLocationSwitch")
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "showMyLocationSwitch")
            
        }
        
    }
    
    var showUseZipeCodeSwitch: Bool {
        
        get {
            
            return defaultPreferences.bool(forKey: "showUseZipCodeSwitch")
            
        }
        
        set(value){
            
            defaultPreferences.set(value, forKey: "showUseZipCodeSwitch")
            
        }
        
    }
    
}
