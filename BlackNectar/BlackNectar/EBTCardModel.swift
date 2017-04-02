//
//  EBTCardModel.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/2/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: Supported States
struct SupportedStates {
    
    let stateID: String
    let stateName: String
    
    static func getSupportedStatesJsonData(from supportedStatesDictionary: NSDictionary) -> SupportedStates? {
        
        return SupportedStates(json: supportedStatesDictionary)
        
    }
    
}

extension SupportedStates {
    
    init?(json: NSDictionary) {
        
        guard let stateID = json["id"] as? String,
            let stateName = json["name"] as? String
            else {
                
                LOG.error("Failed to parse Supported States: \(json)")
                return nil
        }
        
        self.stateID = stateID
        self.stateName = stateName
        
    }
    
}

//MARK: Sign In Requirements, Sign Up Requirements, and Features
struct StateFeaturesAndRequiremets {
    
    let signInRequirements: [SignInRequirements]
    let signUpRequirements: [SignUpRequirements]
    let features: Features
    
    static func getStateFeaturesAndRequirementsJsonData(from statesDictionary: NSDictionary) -> StateFeaturesAndRequiremets? {
        
        return StateFeaturesAndRequiremets(json: statesDictionary)
    }
 
}

