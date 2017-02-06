//
//  UserDefaults.swift
//  BlackNectar
//
//  Created by Kevin Bradbury on 1/18/17.
//  Copyright © 2017 Black Whole. All rights reserved.
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

    func setSideMenuDefaults(in viewController: SideMenuFilterViewController, distanceFilter: Double, isFarmersMarket: Bool, isOpenNow: Bool, isStore: Bool) {
        
        let roundedNumber = (round(defaultPreferences.double(forKey: "distanceFilter") * 100)/100)
        
        viewController.slider.value = Float(defaultPreferences.double(forKey: "distanceFilter"))
        viewController.slideValueLabel.text = "\(roundedNumber)"
        
        if isFarmersMarket {
            
            viewController.styleButtonOn(button: viewController.farmersMarketButton)
            
        } else {
            
            viewController.styleButtonOff(button: viewController.farmersMarketButton)
            
        }
        
        if isOpenNow {
            
            viewController.openNowSwitch.isOn = true
            
        } else {
            
            viewController.openNowSwitch.isOn = false
            
        }
        
        if isStore {
            
            viewController.styleButtonOn(button: viewController.storesButton)
            
        } else {
            
            viewController.styleButtonOff(button: viewController.storesButton)
            
        }
        
    }
    
}
