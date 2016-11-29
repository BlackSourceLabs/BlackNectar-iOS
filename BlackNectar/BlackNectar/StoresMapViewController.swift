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
    private var currentLocation: CLLocationCoordinate2D?
    
    private var stores: [StoresInfo] = []
    typealias Callback = ([StoresInfo]) -> ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLocationManager()
        prepareMapView()
        requestUserLocation()
    }
    
    private func prepareLocationManager() {
        
        // Setting Up Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func requestUserLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Updating users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation: CLLocation = locations.first else {
            return
        }
        
        defer {
            locationManager.stopUpdatingLocation()
        }
        
        currentLocation = userLocation.coordinate
        
        func calculateRegion(for location: CLLocation) -> MKCoordinateRegion {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.05
            let longDelta: CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            return region
        }
        
        let region = calculateRegion(for: userLocation)
        self.mapView.setRegion(region, animated: true)
        
        
        SearchStores.searchForStoresLocations(near: currentLocation!) { stores in
            self.stores = stores
            
            self.populateStoreAnnotations()
        }
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stores = self.stores
    }
    
    func callStoresData(callback: @escaping Callback) {
       
        if currentLocation != nil {
            SearchStores.searchForStoresLocations(near: currentLocation!, callback: callback)
            
        }
    }
        
    
}

