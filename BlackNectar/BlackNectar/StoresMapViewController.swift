//
//  ViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import Kingfisher
import MapKit
import UIKit


class StoresMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentCoordinates: CLLocationCoordinate2D?
    var storesInMapView: [StoresInfo] = []
    var selectedPin: MKPlacemark?
    var distance = 0.0
    var showRestaurants = false
    var showStores = false
    var onlyShowOpenStores = true
    let userLocationManager = UserLocation.instance
    
    typealias Callback = ([StoresInfo]) -> ()
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
    }()
    
    private let main = OperationQueue.main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      UserLocation.instance.requestLocation() { coordinate in
          
            self.prepareMapView()
            self.loadStoresInMapView(at: coordinate)
            self.populateStoreAnnotations()
            
        }
      
      AromaClient.beginMessage(withTitle: "User Entered Map View")
            .addBody("Users location is: \(UserLocation.instance.currentCoordinate)")
            .withPriority(.medium)
            .send()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        guard let region = UserLocation.instance.currentRegion else {
            
            LOG.error("Failed to Update the Users Current Region")
            return
        }
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func populateStoreAnnotations() {
        
        for store in storesInMapView {
            
            let storeName = store.storeName
            let address = store.address.allValues
            let location = store.location
            
            let latitude = location.latitude
            let longitude = location.longitude
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = latitude
            annotation.coordinate.longitude = longitude
            
            annotation.title = storeName
            mapView.addAnnotations([annotation])

        }
        
    }
    
    func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let distanceInMeters = DistanceCalculation.milesToMeters(miles: Double(distance))
        
        SearchStores.searchForStoresLocations(near: coordinate, with: distanceInMeters) { stores in
            
            self.storesInMapView = stores
            
            self.populateStoreAnnotations()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }

}


extension StoresMapViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.black
        pinView?.canShowCallout = true
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        
        button.setBackgroundImage(UIImage(named: "carIcon"), for: .normal)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
        
    }
    
}

extension StoresMapViewController {
    
    func getDrivingDirections(to storeCoordinates: CLLocationCoordinate2D, with storeName: String) -> MKMapItem {
        
        let storePlacemark = MKPlacemark(coordinate: storeCoordinates, addressDictionary: [ "\(title)" : storeName ])
        let storePin = MKMapItem(placemark: storePlacemark)
        storePin.name = storeName
        
        return storePin
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let appleMapslaunchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        if let storeLocation = view.annotation {
            
            let storeName: String = (storeLocation.title ?? nil) ?? "Uknown"
            
            getDrivingDirections(to: storeLocation.coordinate, with: storeName).openInMaps(launchOptions: appleMapslaunchOptions)
            
        }
        
    }
    
}

extension StoresMapViewController {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        
        for annotation in mapView.annotations {
            
            mapView.removeAnnotation(annotation)
            
        }
        
        var cornerCoordinate = CLLocation(coordinate: mapView.centerCoordinate)
        cornerCoordinate.latitude + mapView.region.span.latitudeDelta
        cornerCoordinate.longitude + mapView.region.span.longitudeDelta
        
        let mapViewDistance = DistanceCalculation.getDistance(userLocation: mapView.centerCoordinate, storeLocation: cornerCoordinate)
        
        let distanceInMeters = DistanceCalculation.milesToMeters(miles: mapViewDistance)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchStores.searchForStoresLocations(near: mapView.centerCoordinate, with: distanceInMeters) { stores in
            
            self.storesInMapView = stores
            
            self.populateStoreAnnotations()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
    
}


