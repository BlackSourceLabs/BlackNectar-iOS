//
//  EBT+ViewAccountBalanceTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/15/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_ViewAccountBalanceTests: XCTestCase {
    
    var instance: ViewBalance!
    
    override func setUp() {
        super.setUp()
        
        instance = ViewBalance(name: "user-id", value: "Derodero54321", cashBalance: 60, foodBalance: 100)
    }
    
    func testGetViewBalanceNameJson() {
        let expected = "user-id"
        let result = instance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetViewBalanceValueJson() {
        let expected = "Derodero54321"
        let result = instance.value
        XCTAssertTrue(result == expected)
    }
    
    func testGetCashBalanceJson() {
        let expected = 60
        let result = instance.cashBalance
        XCTAssertTrue(result == expected)
    }
    
    func testGetFoodBalanceJson() {
        let expected = 100
        let result = instance.foodBalance
        XCTAssertTrue(result == expected)
    }
    
}
