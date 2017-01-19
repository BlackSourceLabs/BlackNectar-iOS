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
    
    var isRestaurant: Bool {
        
        get {
            
            return defaultPreferences.bool(forKey: "isRestaurant")
            
        }
        
        set (value){
            
            defaultPreferences.set(value, forKey: "isRestaurant")
            
        }
        
    }
    
    var isStore: Bool {
        
        get {
            
            return defaultPreferences.bool(forKey: "isStore")
            
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

    func setSideMenuDefaults(viewController: SideMenuFilterViewController, distanceFilter: Double, isRestaurant: Bool, isOpenNow: Bool, isStore: Bool) {
        
        let roundedNumber = (round(defaultPreferences.double(forKey: "distanceFilter") * 100)/100)
        
        viewController.slider.value = Float(defaultPreferences.double(forKey: "distanceFilter"))
        viewController.slideValueLabel.text = "\(roundedNumber)"
        
        if isRestaurant {
            
            viewController.styleButtonOn(button: viewController.restaurantButton)
            
        } else {
            
            viewController.styleButtonOff(button: viewController.restaurantButton)
            
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
