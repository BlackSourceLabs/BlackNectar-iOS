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
    var selectedPin: MKPlacemark? = nil
    
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
    
//    func convertHexStringToUIColor(hex:String) -> UIColor {
//        
//    }
    
    func getDirections() {
        
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launcOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launcOptions)
        }
    }
    
    
}


extension StoresMapViewController {
    func dropPinZoomIn(placemark: MKPlacemark) {
        
        selectedPin = placemark
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
     let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.black
        pinView?.isSelected = true
        pinView?.canShowCallout = true
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections) , for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        
        return pinView
    }
    
}

