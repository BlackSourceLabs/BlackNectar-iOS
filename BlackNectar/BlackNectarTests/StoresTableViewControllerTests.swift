//
//  StoresTableViewControllerTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/16/17.
//  Copyright © 2017 BlackSource. All rights reserved.
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
        
        let restaurantAddress = Address(addressLineOne: "737", addressLineTwo: nil, city: "Bronx", state: "NY", county: "NEW YORK", zipCode: "10455", localZipCode: nil)
        let restaurantURL: String = "https://www.pexels.com/photo/salad-healthy-vegetables-vegan-69482/"
        
        guard let restaurantImage = URL(string: restaurantURL) else { return }
        
        let hopeVeganRestaurant = Store(storeName: "HOPE", location: restaurantLocation, address: restaurantAddress, storeImage: restaurantImage, isFarmersMarket: false)
        
        XCTAssertNotNil(storesTableViewController.navigateWithDrivingDirections(toStore: hopeVeganRestaurant))
    }
    
    
}
