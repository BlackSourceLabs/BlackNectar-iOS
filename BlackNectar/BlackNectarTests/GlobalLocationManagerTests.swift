//
//  GlobalLocationManagerTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 1/16/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import CoreLocation
import MapKit
import XCTest

class GlobalLocationManagerTests: XCTestCase {
    
    var userLocation: UserLocation!
    
    override func setUp() {
        super.setUp()
        
        userLocation = UserLocation.instance
        
    }
    
    func testCalculateRegion() {
        
        let cityLatitude: CLLocationDegrees = 40.6782
        let cityLongitude: CLLocationDegrees = -73.9442
        let brooklynNY = CLLocationCoordinate2D(latitude: cityLatitude, longitude: cityLongitude)
        
        XCTAssertNotNil(userLocation.calculateRegion(for: brooklynNY))
        
    }
    
}
