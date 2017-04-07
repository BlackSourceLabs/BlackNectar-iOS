//
//  EBT+SupportedStates.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/6/17.
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
