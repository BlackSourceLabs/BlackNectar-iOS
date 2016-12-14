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
    private var currentLocation: CLLocationCoordinate2D?
    private var stores: [StoresInfo] = []
    var selectedPin: MKPlacemark? = nil
    
    typealias Callback = ([StoresInfo]) -> ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prepareMapView()
        SearchStores.searchForStoresLocations(near: currentLocation!) { stores in
            self.stores = stores
            
            self.populateStoreAnnotations()
        }
        
    }
    
    
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        guard let unwrappedLocation = currentLocation as CLLocationCoordinate2D! else {
            print("could not unwrap currentLocation")
            return
        }
        guard let region = (UserLocation().calculateRegion(for: unwrappedLocation)) as? MKCoordinateRegion else {
            print("could not unwrap region")
            return
        }

        self.mapView.setRegion(region, animated: true)
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

