//
//  EBT+CreateAccount.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: Create Account
struct CreateAccount {
    
    let name: String
    let value: String
    let success: Bool
    let message: String
    
    static func goCreateAccount(from createAccountDictionary: NSDictionary) -> CreateAccount? {
        
        return CreateAccount(fromJSON: createAccountDictionary)
    }
    
}

extension CreateAccount {
    
    init?(fromJSON createAccountDictionary: NSDictionary) {
        
        guard let name = createAccountDictionary["name"] as? String,
            let value = createAccountDictionary["value"] as? String,
            let success = createAccountDictionary["success"] as? Bool,
            let message = createAccountDictionary["message"] as? String
            else {
                
                LOG.error("Failed to Parse Create Account Dictionary: \(createAccountDictionary)")
                return nil
        }
        
        self.name = name
        self.value = value
        self.success = success
        self.message = message
        
    }
    
}
