//
//  UIViewControllers+.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func startSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func stopSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
}
