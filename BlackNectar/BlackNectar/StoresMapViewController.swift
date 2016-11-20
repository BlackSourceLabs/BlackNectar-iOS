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
    
    var locationManager: CLLocationManager!
    
    var currentLatitude = ""
    var currentLongitude = ""
    
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
        
        storesApiCall()
        
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
        
        currentLatitude = "\(location.latitude)"
        currentLongitude = "\(location.longitude)"
        
        self.mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // API Call 
    
    var ebtStores = [StoresInfo]()
    
    func storesApiCall() {
        
        let storesAPI = "http://blacknectar-api.sirwellington.tech:9100/stores"
        
        let url = URL(string: storesAPI)!
        var request = URLRequest.init(url: url)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) {(data, response, error) -> Void in
            
            print("data is : \(data), response is : \(response), error is : \(error)")
            
            guard let taskData = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: taskData, options: []) as! NSArray else {return}
            
            //guard let array = jsonObject["sample-store"] as? NSArray else {return}
            
            
            for i in jsonObject {
                
                let dict = i as? NSDictionary
                guard let storeDictionary = StoresInfo.fromJson(dictionary: dict!) else { return }
                
                self.ebtStores.append(storeDictionary)
                //print("stores: \(self.ebtStores)")
                
                
            }
            self.populateStoreAnnotations()
        }
        dataTask.resume()
    
    }
    
    func populateStoreAnnotations() {
        
        for i in ebtStores {
            
            let storeName = i.storeName
            let address = i.address.allValues
            let location = i.location
            
            let latitude = location["latitude"]
            let longitude = location["longitude"]
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = latitude as! CLLocationDegrees
            print ("\(annotation.coordinate.latitude)")
            annotation.coordinate.longitude = longitude as! CLLocationDegrees
            print("\(annotation.coordinate.longitude)")
            
            annotation.subtitle = "\(storeName)"
            mapView.addAnnotations([annotation])
        }
        
    }
    

}

