//
//  DistanceCalculationTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/16/17.
//  Copyright © 2017 Black Whole. All rights reserved.
//

@testable import BlackNectar

import CoreLocation
import XCTest

class DistanceCalculationTests: XCTestCase {
    
    func testGetDistance() {
        
        let usersLatitude: CLLocationDegrees = 40.6782
        let usersLongitude: CLLocationDegrees = -73.9442
        let usersLocation = CLLocationCoordinate2D(latitude: usersLatitude, longitude: usersLongitude)
        
        let restaurantsLatitude: CLLocationDegrees = 34.14341
        let restaurantsLongitude: CLLocationDegrees = -118.392
        let restaurantsLocation = CLLocationCoordinate2D(latitude: restaurantsLatitude, longitude: restaurantsLongitude)
        
        XCTAssertNotNil(DistanceCalculation.getDistance(userLocation: usersLocation, storeLocation: restaurantsLocation))
        
    }
    
    func testMilesToMeters() {
        
        let miles: Double = 5000
        
        XCTAssertNotNil(DistanceCalculation.milesToMeters(miles: miles))
        
        
    }
    
    func testMetersToMiles() {
        
        let meters: Double = 5000
        
        XCTAssertNotNil(DistanceCalculation.metersToMiles(meters: meters))
        
    }
    
    func testMilesToMetersWithBadArgs() {
        
        let miles: Double = -5000
        
        XCTAssertNotNil(DistanceCalculation.milesToMeters(miles: miles))
        
    }
    
    func testMetersToMilesWithBadArgs() {
        
        let meters: Double = -5000
        
        XCTAssertNotNil(DistanceCalculation.metersToMiles(meters: meters))
        
    }
    
}

