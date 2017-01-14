//
//  CustomAnnotation.swift
//  BlackNectar
//
//  Created by Kevin Bradbury on 1/13/17.
//  Copyright © 2017 Black Whole. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
   
    var identifier = "store location"
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        title = name
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }

}
