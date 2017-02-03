//
//  StoresMapViewControllerTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/16/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import MapKit
import XCTest

class StoresMapViewControllerTests: XCTestCase {
    
    var storesMapViewController: StoresMapViewController!
    
    override func setUp() {
        super.setUp()
        
        storesMapViewController = StoresMapViewController()
        
    }
    
    func testLoadStoresInMapView() {
        
        let cityLatitude: CLLocationDegrees = 40.6782
        let cityLongitude: CLLocationDegrees = -73.9442
        let brooklynNY = CLLocationCoordinate2D(latitude: cityLatitude, longitude: cityLongitude)
        
        XCTAssertNotNil(storesMapViewController.loadStoresInMapView(at: brooklynNY))
        
    }
    
    func testCreateAnnotations() {
        
        let restaurantlatitude: CLLocationDegrees = 34.14341
        let restaurantlongitude: CLLocationDegrees = -118.392
        let restaurantLocation = CLLocationCoordinate2D(latitude: restaurantlatitude, longitude: restaurantlongitude)
        
        let restaurantAddress: NSDictionary = ["address" : "11943 W Ventura blvd"]
        let restaurantURL: String = "https://www.pexels.com/photo/salad-healthy-vegetables-vegan-69482/"
        
        guard let restaurantImage = URL(string: restaurantURL) else { return }
        
        let hopeVeganRestaurant = StoresInfo(storeName: "HOPE", location: restaurantLocation, address: restaurantAddress, storeImage: restaurantImage, isFarmersMarket: false)
        
        XCTAssertNotNil(storesMapViewController.createAnnotation(forStore: hopeVeganRestaurant))
        
    }
    
    func testGetDrivingDirections() {
        
        let restaurantLatitude: CLLocationDegrees = 34.14341
        let restaurantLongitude: CLLocationDegrees = -118.392
        let restaurantLocation = CLLocationCoordinate2D(latitude: restaurantLatitude, longitude: restaurantLongitude)
        
        let restaurantName = "HOPE"
        
        XCTAssertNotNil(storesMapViewController.getDrivingDirections(to: restaurantLocation, with: restaurantName))
        
    }
    
    

    
}
