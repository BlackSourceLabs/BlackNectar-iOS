//
//  Colors.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/8/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

public class Colors {
    
    public static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return fromRGBA(red: red, green: green, blue: blue, alpha: 100)
        
    }
    
    public static func fromRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/100)
        
    }

}
