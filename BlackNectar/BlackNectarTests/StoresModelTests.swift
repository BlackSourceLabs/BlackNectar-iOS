//
//  StoresDataStructTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import Archeota
import CoreLocation
import MapKit
import XCTest

class StoresDataStructTests: XCTestCase {
    
    var instance: Store!
    
    override func setUp() {
        super.setUp()
        
        instance = Store(storeName: "Trader Joes", location: CLLocationCoordinate2DMake(-40.74098, 96.67651),
                         address: Address(addressLineOne: "3120 Pine Lake Rd", addressLineTwo: "", city: "Lincoln", state: "NE", county: "", zipCode: "68516", localZipCode: ""),
                         storeImage: URL(string:"http://upstater.com/wp-content/uploads/2016/04/trader-joes-wiki.jpg")!, isFarmersMarket: false)
        
    }
    
    //MARK: Check Your work, Run Tests
    func testGetStoreNameJson() {
        XCTAssertNotNil(instance.storeName)
        LOG.info("test store name: \(instance.storeName)")
    }
    
    func testGetStoreLocationJson() {
        XCTAssertNotNil(instance.location)
        LOG.info("test store location: \(instance.location)")
    }
    
    func testGetStoreAddressJson() {
        XCTAssertNotNil(instance.address)
        LOG.info("test store address: \(instance.address)")
    }
    
    func testGetStoreImageJson() {
        XCTAssertNotNil(instance.storeImage)
        LOG.info("test store image: \(instance.storeImage)")
    }
    
    func testGetStoreFarmersMarketJson() {
        XCTAssertNotNil(instance.isFarmersMarket)
        LOG.info("test farmers market: \(instance.isFarmersMarket)")
    }
    
    
    //MARK: Double Check Your Work, Run Tests Again
    func testGetStoreNameJsonAgain() {
        let expected = "Trader Joes"
        let result = instance.storeName
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreLocationJsonAgain() {
        let expected = CLLocationCoordinate2DMake(-40.74098, 96.67651)
        let result = instance.location
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreImageJsonAgain() {
        let expected = URL(string:"http://upstater.com/wp-content/uploads/2016/04/trader-joes-wiki.jpg")
        let result = instance.storeImage
        XCTAssertTrue(result == expected)
    }
    
    func getStoreFarmersMarketJsonAgain() {
        let expected = false
        let result = instance.isFarmersMarket
        XCTAssertTrue(result == expected)
    }
    
    //MARK: Address Struct
    func testGetStoreAddressLineOneJsonAgain() {
        let expected = "3120 Pine Lake Rd"
        let result = instance.address.addressLineOne
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreAddressLineTwoJsonAgain() {
        let excpected = ""
        let result = instance.address.addressLineTwo
        XCTAssertTrue(result == excpected)
    }
    
    func testGetStoreAddressCityJsonAgain() {
        let expected = "Lincoln"
        let result = instance.address.city
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreAddressStateJsonAgain() {
        let expected = "NE"
        let result = instance.address.state
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreAddressCountyJsonAgain() {
        let expected = ""
        let result = instance.address.county
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreAddressZipCodeJsonAgain() {
        let expected = "68516"
        let result = instance.address.zipCode
        XCTAssertTrue(result == expected)
    }
    
    func testGetStoreAddressLocalZipCodeJsonAgain() {
        let expected = ""
        let result = instance.address.localZipCode
        XCTAssertTrue(result == expected)
    }
    
}
