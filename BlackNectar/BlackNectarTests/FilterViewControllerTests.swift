//
//  FilterViewControllerTests.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 2/16/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import Foundation
import XCTest
import MapKit

class FilterViewControllerTests: XCTest {
    
    var instance: FilterViewController!
    var showFarmersMarket: Bool!
    var showStores: Bool!
    var location: CLLocationCoordinate2D!
    
    override func setUp() {
        instance = FilterViewController()
        showFarmersMarket = UserPreferences.instance.showFarmersMarkets
        showStores = UserPreferences.instance.showStores
        location = CLLocationCoordinate2D(latitude: 34.013301225566224, longitude: -118.49432824285998)
    }
    
    override func tearDown() {
        UserPreferences.instance.showStores = showStores
        UserPreferences.instance.showFarmersMarkets = showFarmersMarket
    }
    
    func testFarmersMarket() {
        let expected = UserPreferences.instance.showFarmersMarkets
        let result = instance.showFarmersMarkets
        XCTAssertTrue(result == expected)
    }
    
    func testStores() {
        let expected = UserPreferences.instance.showStores
        let result = instance.showGroceryStores
        XCTAssertTrue(result == expected)
    }
    
    func testOnGroceryStores() {
        let expected = !showStores
        instance.onGroceryStores(UIButton())
        
        let result = instance.showGroceryStores
        XCTAssertTrue(result == expected)
    }
    
    func testOnFarmersMarkets() {
        let expected = !showFarmersMarket
        
        instance.onFarmersMarkets(UIButton())
        let result = instance.showFarmersMarkets
        XCTAssertTrue(result == expected)
    }
    
    func testLoadStores() {
        instance.loadStoresInMapView(at: location)
    }
}
