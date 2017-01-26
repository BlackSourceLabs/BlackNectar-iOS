//
//  Arrays+.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/25/17.
//  Copyright © 2017 Black Whole. All rights reserved.
//

import Foundation

extension Array {
    
    var notEmpty: Bool {
        return !isEmpty
    }
    
    /**
        Tells whether the specified index is in bounds of the array.
        Use this check with indexes before accessing the array.
    */
    func isInBounds(index: Int) -> Bool {
        
        return index >= 0 && index < self.count
    }
}
