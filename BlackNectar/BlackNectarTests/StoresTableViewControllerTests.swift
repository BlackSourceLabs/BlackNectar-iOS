//
//  StoresTableViewControllerTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/16/17.
//  Copyright © 2017 Black Whole. All rights reserved.
//

@testable import BlackNectar

import MapKit
import XCTest

class StoresTableViewControllerTests: XCTestCase {
    
    var storesTableViewController: StoresTableViewController!
    
    override func setUp() {
        super.setUp()
        
        storesTableViewController = StoresTableViewController()
        
    }
    
    func testLoadStores() {
        
        let cityLatitude: CLLocationDegrees = 40.6782
        let cityLongitude: CLLocationDegrees = -73.9442
        let brooklynNY = CLLocationCoordinate2D(latitude: cityLatitude, longitude: cityLongitude)
        
        XCTAssertNotNil(storesTableViewController.loadStores(at: brooklynNY))
        
    }
    
    func testNavigateToStore() {
        
        let restaurantLatitude: CLLocationDegrees = 34.14341
        let restaurantLongitude: CLLocationDegrees = -118.392
        let restaurantLocation = CLLocationCoordinate2D(latitude: restaurantLatitude, longitude: restaurantLongitude)
        
        let restaurantAddress: NSDictionary = ["address" : "11943 W Ventura blvd"]
        let restaurantURL: String = "https://www.pexels.com/photo/salad-healthy-vegetables-vegan-69482/"
        
        guard let restaurantImage = URL(string: restaurantURL) else { return }
        
        let hopeVeganRestaurant = StoresInfo(storeName: "HOPE", location: restaurantLocation, address: restaurantAddress, storeImage: restaurantImage, isFarmersMarket: false)
        
        XCTAssertNotNil(storesTableViewController.navigateWithDrivingDirections(toStore: hopeVeganRestaurant))
    }
    
    
}
