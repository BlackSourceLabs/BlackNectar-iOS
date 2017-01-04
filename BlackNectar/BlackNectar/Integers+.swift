//
//  Integers+.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/29/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    
    var bytes: Int { return self }
    var kb: Int { return bytes * 1024 }
    var mb: Int { return kb * 1024 }
    
}
