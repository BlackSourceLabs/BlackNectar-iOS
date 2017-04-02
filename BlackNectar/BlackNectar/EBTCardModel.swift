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

