//
//  ViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import AromaSwiftClient
import CoreLocation
import Foundation
import Kingfisher
import MapKit
import UIKit



class StoresMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    private var storesInMapView: [StoresInfo] = []
    var selectedPin: MKPlacemark? = nil
    
    typealias Callback = ([StoresInfo]) -> ()
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
    }()
    
    private let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMapView()
        AromaClient.beginMessage(withTitle: "User Entered Map View")
            .addBody("Users location is: \(UserLocation.instance.currentCoordinate)")
            .withPriority(.medium)
            .send()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let currentLocation = UserLocation.instance.currentCoordinate {
            
            loadStoresInMapView(at: currentLocation)
        }
            
        else {
            
            UserLocation.instance.requestLocation() { coordinate in
                self.loadStoresInMapView(at: coordinate)
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        guard let region = UserLocation.instance.currentRegion else {
            
            return
        }
        
        self.mapView.setRegion(region, animated: true)
    }

    // populating stores as annotations in the mapView
    func populateStoreAnnotations() {
        
        for store in storesInMapView {
            
            let storeName = store.storeName
            let address = store.address.allValues
            let location = store.location
            
            let latitude = location["latitude"]
            let longitude = location["longitude"]
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = latitude as! CLLocationDegrees
            annotation.coordinate.longitude = longitude as! CLLocationDegrees
            
            self.main.addOperation {
                
                self.mapView.addAnnotations([annotation])
                
            }
            
        }
        
    }
    
    private func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchStores.searchForStoresLocations(near: coordinate) { stores in
            self.storesInMapView = stores
            
            self.populateStoreAnnotations()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
    
    func getDirections() {
        
        if let selectedPin = selectedPin {
            
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
            
        }
        
        AromaClient.sendMediumPriorityMessage(withTitle: "Navigating to Store", withBody: "User is getting directions to store: \(selectedPin)")
        
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
