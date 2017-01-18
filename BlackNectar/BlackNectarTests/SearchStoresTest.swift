//
//  SearchStoresTest.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/17/17.
//  Copyright © 2017 Black Whole. All rights reserved.
//

@testable import BlackNectar

import MapKit
import XCTest


class SearchStoresTest: XCTestCase {
    
    struct testStoreInfo {
        
        let storeName: String
        let storeLocation: CLLocationCoordinate2D
        let storeAddress: NSDictionary
        let storeImage: URL
        
    }
    
    typealias testCallback = ([testStoreInfo]) -> ()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testSearchForStoresLocations() {
        
        let usersLatitude: CLLocationDegrees = 40.6782
        let usersLongitude: CLLocationDegrees = -73.9442
        let userslocation = CLLocationCoordinate2D(latitude: usersLatitude, longitude: usersLongitude)
        
        let storeDistance: Double = 15.5
        
        
        XCTAssertNotNil(SearchStores.searchForStoresLocations(near: userslocation, with: storeDistance, callback: testCallback))
        
    }
    
}
