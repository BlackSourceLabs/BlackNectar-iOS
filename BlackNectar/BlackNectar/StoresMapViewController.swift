//
//  ViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation


class StoresMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var stores: [StoresInfo] = []
    
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing locationManager, setting the delegate, accuracy, filter and requesting authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    
    // Updating users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        currentLocation = location
        
        self.mapView.setRegion(region, animated: true)
        
        SearchStores.searchForStoresLocations(near: currentLocation!) { stores in
            self.stores = stores
        }
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // populating stores as annotations in the mapView
    
        func populateStoreAnnotations() {
        
        for store in stores {
            
            let storeName = store.storeName
            let address = store.address.allValues
            let location = store.location
            
            let latitude = location["latitude"]
            let longitude = location["longitude"]
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = latitude as! CLLocationDegrees
            annotation.coordinate.longitude = longitude as! CLLocationDegrees
            
            annotation.subtitle = "\(storeName)"
            mapView.addAnnotations([annotation])
        }
        
    }
    
}

