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
    
    var isFarmersMarket: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: "isFarmersMarket") as? Bool ?? true
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "isFarmersMarket")
            
        }
        
    }
    
    var isStore: Bool {
        
        get {
            
            return defaultPreferences.object(forKey: "isStore") as? Bool ?? true
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "isStore")
            
        }
        
    }
    
    var isOpenNow: Bool {
        
        get {
            
            return defaultPreferences.bool(forKey: "isOpenNow")
            
        }
        
        set (value) {
            
            defaultPreferences.set(value, forKey: "isOpenNow")
            
        }
        
    }
    
}
