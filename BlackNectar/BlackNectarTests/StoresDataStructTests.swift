//
//  StoresDataStructTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import CoreLocation
import MapKit
import XCTest


class StoresDataStructTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFromJson() {
        
        let restaurantName = "store_name"
        let restaurantLocation = String()
        let restaurantAddress = String()
        let storeImage = String()
        let restaurantInfo: NSDictionary = [restaurantName : "11943 W Ventura blvd",
                                            restaurantLocation : "Los Angeles, CA",
                                            restaurantAddress : "11943 W Ventura blvd",
                                            storeImage : "What a beautiful picture"]
        
        let result = Store.getStoreJsonData(from: restaurantInfo)
        XCTAssertTrue(result != nil)
    }
    
}
