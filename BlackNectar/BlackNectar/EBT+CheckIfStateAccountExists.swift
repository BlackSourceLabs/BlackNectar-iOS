//
//  EBT+CheckIfStateAccountExists.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: Check If State Account Exists
struct CheckStateAccountExists {
    
    let name: String
    let value: String
    let exists: Bool
    let message: String
    
    static func goCheckToSeeIfStateAccountExists(from checkStateAccountDictionary: NSDictionary) -> CheckStateAccountExists? {
        
        return CheckStateAccountExists(fromJSON: checkStateAccountDictionary)
    }
    
}

extension CheckStateAccountExists {
    
    init?(fromJSON checkStateAccountExistsDictionary: NSDictionary) {
        
        guard let name = checkStateAccountExistsDictionary["name"] as? String,
            let value = checkStateAccountExistsDictionary["value"] as? String,
            let exists = checkStateAccountExistsDictionary["exists"] as? Bool,
            let message = checkStateAccountExistsDictionary["message"] as? String
            else {
                
                LOG.error("Failed to Parse Check State Account Exists: \(checkStateAccountExistsDictionary)")
                return nil
        }
        
        self.name = name
        self.value = value
        self.exists = exists
        self.message = message
        
    }
    
}
