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
import Kingfisher


class StoresMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var stores: [StoresInfo]? = []
    private var currentLocation: CLLocationCoordinate2D?
    
    var selectedPin: MKPlacemark? = nil
    let userLocationManager = UserLocation.instance
    var distance = 0.0
    var showRestaurants = false
    var showStores = false
    var onlyShowOpenStores = true
    
    typealias Callback = ([StoresInfo]) -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let currentLocation = UserLocation.instance.currentCoordinate {
            
            if stores != nil {
                
                populateStoreAnnotations()
                
            } else {
                
                loadStoresInMapView(at: currentLocation)

            }
            
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
        
        guard var region = UserLocation.instance.currentRegion else {
            
            return
        }
        
        let latitude = DistanceCalculation.milesToMeters(miles: region.span.latitudeDelta)
        let longitude = DistanceCalculation.milesToMeters(miles: region.span.longitudeDelta)
        
        region.span.latitudeDelta = latitude / 1000
        region.span.longitudeDelta = longitude / 1000
        
        self.mapView.setRegion(region, animated: true)
    }
    
    
    // populating stores as annotations in the mapView
    
    func populateStoreAnnotations() {
        
        if stores != nil {
            
            for store in stores! {
                
                if store != nil {
                    
                    guard let storeName = store.storeName as? String else { return }
                    let address = store.address.allValues
                    let location = store.location
                    
                    let latitude = location.latitude
                    let longitude = location.longitude
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate.latitude = latitude as! CLLocationDegrees
                    annotation.coordinate.longitude = longitude as! CLLocationDegrees
                    
                    annotation.title = storeName
                    mapView.addAnnotations([annotation])
                  
                }
                
            }
            
        }
        
    }
    
    
    private func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchStores.searchForStoresLocations(near: coordinate, with: distance) { stores in
            
            print("mapView distance is : \(self.distance)")
            
            self.stores = stores
            
            self.populateStoreAnnotations()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        view.setSelected(true, animated: true)
        
    }
    
    
    func getDirections() {
        
        if let selectedPin = selectedPin {
            
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
            
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
