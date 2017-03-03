//
//  Fonts.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/8/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

class Fonts {
    
    static let oxygenBold = UIFont(name: "Oxygen-Bold", size: 16)!
    static let oxygenRegular = UIFont(name: "Oxygen-Regular", size: 16)!
  
    static func uniSansRegular(size: CGFloat = 16) -> UIFont? {
        
        return UIFont(name: "UniSansRegular", size: size)
    }
    
    static func uniSansSemiBold(size: CGFloat = 16) -> UIFont? {
        
        return UIFont(name: "UniSansSemiBold", size: size)
    }
    
    static func uniSansLight(size: CGFloat = 16) -> UIFont? {
        
        return UIFont(name: "UniSansLight", size: size)
    }
    
    static func uniSansBold(size: CGFloat = 16) -> UIFont? {
        
        return UIFont(name: "UniSansBold", size: size)
    }
}
