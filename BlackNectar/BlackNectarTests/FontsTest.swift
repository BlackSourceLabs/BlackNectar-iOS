//
//  FontsTest.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 3/15/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import Foundation
import UIKit
import XCTest

class FontsTest : XCTestCase {
    
    override func setUp() {
        
    }
    
    
    func testFonts() {
        
        var font: UIFont = Fonts.oxygenRegular
        print("\(font)")
        font = Fonts.oxygenBold
        print("\(font)")
    }
    
    func testUniSans() {
    
        var uni = Fonts.uniSansBold()!
        uni = Fonts.uniSansLight()!
        uni = Fonts.uniSansRegular()!
        uni = Fonts.uniSansSemiBold()!
        
    }
}
