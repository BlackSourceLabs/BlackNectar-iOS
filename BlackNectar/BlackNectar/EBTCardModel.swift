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

extension StateFeaturesAndRequiremets {
    
    init?(json: NSDictionary) {
        
        guard let signInRequirementsJSON = json["sign_in_requirements"] as? NSDictionary,
            let signUpRequirementsJSON = json["sign_up_requirements"] as? NSDictionary,
            let featuresJSON = json["features"] as? NSDictionary
            else {
                
                LOG.error("Failed to Parse State Features and Requirements: \(json)")
                return nil
        }
        
        guard let signInRequirements = SignInRequirements(from: signInRequirementsJSON) else { return nil }
        guard let signUpRequirements = SignUpRequirements(from: signUpRequirementsJSON) else { return nil }
        guard let features = Features(from: featuresJSON) else { return nil }
        
        self.signInRequirements = [signInRequirements]
        self.signUpRequirements = [signUpRequirements]
        self.features = features
        
    }
    
}

