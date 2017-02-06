//
//  TimeIntervals+.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/29/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit

extension TimeInterval {
    
    var seconds: Double { return self }
    var minutes: Double { return self * 60 }
    var hours: Double { return minutes * 60 }
    var days: Double { return hours * 24 }
    
}
