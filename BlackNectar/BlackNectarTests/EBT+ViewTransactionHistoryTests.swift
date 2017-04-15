//
//  EBT+ViewTransactionHistoryTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/15/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_ViewTransactionHistoryTests: XCTestCase {
    
    var instance: ViewTransactionHistory!
    
    override func setUp() {
        super.setUp()
        
        instance = ViewTransactionHistory(name: "user-id", value: "Derodero54321", timestamp: Timestamp.init(seconds: 150, nano: 0),
                                          amount: 390.22, address: "1000 Santa Monica Blvd Santa Monica, CA", retailer: "VONS",
                                          transactionType: TransactionType.init(charge: "Charge Successful", deposit: "Deposit Successful"), type: "Cold Food")
    }
    
    func testGetTransactionHistoryNameJson() {
        let expected = "user-id"
        let result = instance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionHistoryValueJson() {
        let expected = "Derodero54321"
        let result = instance.value
        XCTAssertTrue(result == expected)
    }
    
    func testGetTimestampSecondsJson() {
        let expected = 150
        let result = instance.timestamp.seconds
        XCTAssertTrue(result == expected)
    }
    
    func testGetTimestampNanoJson() {
        let expected = 0
        let result = instance.timestamp.nano
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionHistoryAmountJson() {
        let expected = 390.22
        let result = instance.amount
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionHistoryAddressJson() {
        let expected = "1000 Santa Monica Blvd Santa Monica, CA"
        let result = instance.address
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionHistoryRetailerJson() {
        let expected = "VONS"
        let result = instance.retailer
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionTypeChargeJson() {
        let expected = "Charge Successful"
        let result = instance.transactionType.charge
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionTypeDepositJson() {
        let expected = "Deposit Successful"
        let result = instance.transactionType.deposit
        XCTAssertTrue(result == expected)
    }
    
    func testGetTransactionHistoryTypeJson() {
        let expected = "Cold Food"
        let result = instance.type
        XCTAssertTrue(result == expected)
    }
    
}
