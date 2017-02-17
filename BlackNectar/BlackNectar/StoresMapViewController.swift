//
//  ViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/19/16.
//  Copyright © 2017 BlackSource. All rights reserved.
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
    
    var stores: [Store] = []
    
    var selectedPin: MKPlacemark?
    var distance = 0.0
    
    var showFarmersMarkets: Bool {
        return UserPreferences.instance.showFarmersMarkets
    }
    
    var showStores: Bool {
        return UserPreferences.instance.showStores
    }
    
    var onlyShowOpenStores = true
    
    var mapViewLoaded = false
    
    
    fileprivate let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
    }()
    
    fileprivate let main = OperationQueue.main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMapView()
        loadStores()
        userLocationInfoForAroma()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    private func loadStores() {
        
        UserLocation.instance.requestLocation() { coordinate in
            
            self.loadStoresInMapView(at: coordinate)
            
        }
        
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
    
}

//MARK: Loading Stores Into mapView
extension StoresMapViewController {
    
    func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        startSpinningIndicator()
        
        SearchStores.searchForStoresLocations(near: coordinate) { stores in
            
            self.stores = self.filterStores(from: stores)
            
            self.main.addOperation {
                
                self.populateStoreAnnotations()
                self.stopSpinningIndicator()
                
            }
            
            if self.stores.isEmpty {
                
                self.makeNoteThatNoStoresFound(additionalMessage: "User is in Stores Map View")
                
            }
            
        }
        
    }
    
    private func filterStores(from stores: [Store]) -> [Store] {
        
        if showStores == showFarmersMarkets {
            return stores
        }
        
        if showStores {
            return stores.filter() { $0.notFarmersMarket }
        }
        
        if showFarmersMarkets {
            return stores.filter() { $0.isFarmersMarket }
        }
        
        return stores
        
    }
    
    func populateStoreAnnotations() {
        
        var annotations: [MKAnnotation] = []
        
        for store in stores {
            
            let annotation = createAnnotation(forStore: store)
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        mapView.removeNonVisibleAnnotations()
        
    }
    
    func createAnnotation(forStore store: Store) -> CustomAnnotation {
        
        let storeName = store.storeName
        let location = store.location
        
        let latitude = location.latitude
        let longitude = location.longitude
        
        let annotation = CustomAnnotation(name: storeName, latitude: latitude, longitude: longitude)
        
        return annotation
        
    }
    
}


//MARK: Map View Delegate Methods
extension StoresMapViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotation = annotation as? CustomAnnotation
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        let blackNectarPin = UIImage(named: "BlackNectarMapPin")
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation?.identifier)
        
        button.setBackgroundImage(UIImage(named: "carIcon"), for: .normal)
        
        annotationView.canShowCallout = true
        annotationView.leftCalloutAccessoryView = button
        annotationView.image = blackNectarPin
        
        return annotationView
        
    }
    
}

//MARK: Gets Directions
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
            
            AromaClient.beginMessage(withTitle: "User tapped on \(storeName) map pin")
                .addBody("User navigated to \(storeName)\nstore coordinates: \(storeLocation.coordinate)\n(Map View)")
                .withPriority(.medium)
                .send()
            
        }
        
    }
    
}

extension StoresMapViewController {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        
        let center = mapView.centerCoordinate
        
        LOG.debug("User dragged Map Screen to: \(center)")
        
        self.loadStoresInMapView(at: center)
        
    }
    
}


extension MKMapView {
    
    func isVisible(annotation: MKAnnotation) -> Bool {
        
        let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
        
        return MKMapRectContainsPoint(self.visibleMapRect, annotationPoint)
        
    }
    
    func removeNonVisibleAnnotations() {
        
        self.annotations
            .filter({ !isVisible(annotation: $0) })
            .forEach({ self.removeAnnotation($0) })
        
    }
    
    func removeVisibleAnnotations() {
        
        self.annotations
            .filter({ isVisible(annotation: $0) })
            .forEach({ self.removeAnnotation($0) })
        
    }
    
}

extension StoresMapViewController {
    
    func makeNoteThatNoStoresFound(additionalMessage: String = "") {
        
        LOG.warn("There are no stores around the users location (Stores loading result is 0)")
        AromaClient.beginMessage(withTitle: "No stores loading result is 0")
            .addBody("Users location is: \(UserLocation.instance.currentLocation)\n (Stores loading result is 0 : \(additionalMessage)")
            .withPriority(.high)
            .send()
        
    }
    
    func userLocationInfoForAroma() {
        
        guard let userLocationForAroma = UserLocation.instance.currentCoordinate else { return }
        
        AromaClient.beginMessage(withTitle: "User Entered Map View")
            .addBody("User Location is: \(userLocationForAroma)")
            .withPriority(.low)
            .send()
        
    }
    
}




