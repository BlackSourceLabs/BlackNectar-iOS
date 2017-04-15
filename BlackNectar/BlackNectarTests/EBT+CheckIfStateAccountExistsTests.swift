//
//  EBT+CheckIfStateAccountExistsTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/15/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_CheckIfStateAccountExistsTests: XCTestCase {
    
    var instance: CheckStateAccountExists!
    
    override func setUp() {
        super.setUp()
        
        instance = CheckStateAccountExists(name: "user-id", value: "Derodero54321", exists: true, message: "Your account does not exist. Please create an account")
    }
    
    func testGetStateAccountNameJson() {
        let expected = "user-id"
        let result = instance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetStateAccountValueJson() {
        let expected = "Derodero54321"
        let result = instance.value
        XCTAssertTrue(result == expected)
    }
    
    func testGetStateAccountExistsJson() {
        let expected = true
        let result = instance.exists
        XCTAssertTrue(result == expected)
    }
    
    func testGetStateAccountMessageJson() {
        let expected = "Your account does not exist. Please create an account"
        let result = instance.message
        XCTAssertTrue(result == expected)
    }
    
}
