//
//  EBT+SupportedStatesTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/14/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_SupportedStatesTests: XCTestCase {
    
    var instance: SupportedStates!
    
    override func setUp() {
        super.setUp()
        
        instance = SupportedStates(stateID: "CA", stateName: "California")
    }
    
    func testGetStateIDJson() {
        let expected = "CA"
        let result = instance.stateID
        XCTAssertTrue(result == expected)
    }
    
    func testGetStateNameJson() {
        let expected = "California"
        let result = instance.stateName
        XCTAssertTrue(result == expected)
    }
    
}
