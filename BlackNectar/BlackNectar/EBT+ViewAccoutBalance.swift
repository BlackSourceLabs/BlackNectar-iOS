//
//  EBT+ViewAccoutBalance.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: View Account Balance
struct ViewBalance {
    
    let name: String
    let value: String
    let cashBalance: Int
    let foodBalance: Int
    
    static func goViewBalance(from viewBalanceDictionary: NSDictionary) -> ViewBalance? {
        
        return ViewBalance(fromJSON: viewBalanceDictionary)
    }
    
}

extension ViewBalance {
    
    init?(fromJSON viewBalanceDictionary: NSDictionary) {
        
        guard let name = viewBalanceDictionary["name"] as? String,
            let value = viewBalanceDictionary["value"] as? String,
            let cashBalance = viewBalanceDictionary["cash_balance"] as? Int,
            let foodBalance = viewBalanceDictionary["view_balance"] as? Int
            else {
                
                LOG.error("Failed to Parse View Balance Dictionary: \(viewBalanceDictionary)")
                return nil
        }
        
        self.name = name
        self.value = value
        self.cashBalance = cashBalance
        self.foodBalance = foodBalance
        
    }
    
}
