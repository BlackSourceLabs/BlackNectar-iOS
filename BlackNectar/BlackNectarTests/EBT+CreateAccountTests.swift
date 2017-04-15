//
//  EBT+CreateAccountTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/15/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_CreateAccountTests: XCTestCase {
    
    var instance: CreateAccount!
    
    override func setUp() {
        super.setUp()
        
        instance = CreateAccount(name: "user-id", value: "Derodero54321", success: true, message: "Your account was not created. Please try again")
    }
    
    func testGetCreateAccountNameJson() {
        let expected = "user-id"
        let result = instance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetCreateAccountValueJson() {
        let expected = "Derodero54321"
        let result = instance.value
        XCTAssertTrue(result == expected)
    }
    
    func testGetCreateAccountSuccessJson() {
        let expected = true
        let result = instance.success
        XCTAssertTrue(result == expected)
    }
    
    func testGetCreateAccountMessageJson() {
        let expected = "Your account was not created. Please try again"
        let result = instance.message
        XCTAssertTrue(result == expected)
    }
    
}
