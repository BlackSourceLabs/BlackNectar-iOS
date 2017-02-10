//
//  FilterViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import Kingfisher
import MapKit
import UIKit

protocol FilterDelegate {
    
    func didSelectFilters(_ : FilterViewController, farmersMarkets: Bool, groceryStores: Bool, coordinate: CLLocationCoordinate2D)
    
}

class FilterViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var farmersMarketsButton: UIButton!
    @IBOutlet weak var groceryStoresButton: UIButton!
    
    var currentCoordinates: CLLocationCoordinate2D?
    
    var showFarmersMarkets: Bool {
        
        get {
            
            return UserPreferences.instance.isFarmersMarket
        }
        
        set {
            
            UserPreferences.instance.isFarmersMarket = newValue
            
        }
        
    }
    
    var showGroceryStores: Bool {
        
        get {
            return UserPreferences.instance.isStore
            
        }
        
        set {
            UserPreferences.instance.isStore = newValue
            
        }
        
    }
    
    var delegate: FilterDelegate?
    var distance = 0.0
    
    fileprivate var stores: [Store] = []
    fileprivate var selectedPin: MKPlacemark?
    fileprivate let blackNectarPin = UIImage(named: "BlackNectarMapPin")
    
    
    fileprivate let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        
        return operationQueue
        
    }()
    
    fileprivate let main = OperationQueue.main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMapView()
        userLocationInfoForAroma()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        styleGroceryStores()
        styleFarmersMarkets()
        
    }
    
    
    //MARK: Filter Buttons Code
    @IBAction func onFarmersMarkets(_ sender: UIButton) {
        
        showFarmersMarkets = !showFarmersMarkets
        styleFarmersMarkets()
        mapView.removeVisibleAnnotations()
        loadStores()
        
    }
    
    @IBAction func onGroceryStores(_ sender: UIButton) {
        
        showGroceryStores = !showGroceryStores
        styleGroceryStores()
        mapView.removeVisibleAnnotations()
        loadStores()
        
    }
    
    fileprivate func styleFarmersMarkets() {
        
        if showFarmersMarkets {
            
            showFarmersMarkets = true
            styleButtonOn(button: farmersMarketsButton)
            
        } else {
            
            showFarmersMarkets = false
            styleButtonOff(button: farmersMarketsButton)
            
        }
        
    }
    
    fileprivate func styleGroceryStores() {
        
        if showGroceryStores {
            
            showGroceryStores = true
            styleButtonOn(button: groceryStoresButton)
            
        } else {
            
            showGroceryStores = false
            styleButtonOff(button: groceryStoresButton)
            
        }
        
    }
    
    private func loadStores() {
        
        UserLocation.instance.requestLocation { coordinate in
            
            self.loadStoresInMapView(at: coordinate)
            
        }
        
    }
    
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        guard let region = UserLocation.instance.currentRegion else {
            
            LOG.error("Failed to load the Users Current Region")
            return
        }
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
}

//MARK: Loads Stores into Map View and when User Pans
extension FilterViewController {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        
        LOG.debug("User dragged Map Screen to: \(center)")
        
        self.loadStoresInMapView(at: center)
        
    }
    
    func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        startSpinningIndicator()
        
        let distanceInMeters = DistanceCalculation.milesToMeters(miles: Double(distance))
        
        SearchStores.searchForStoresLocations(near: coordinate, with: distanceInMeters) { stores in
            
            self.stores = stores
            
            self.main.addOperation {
                
                self.populateStoreAnnotations()
                self.stopSpinningIndicator()
                
            }
            
        }
        
        if self.stores.isEmpty {
            
            self.makeNoteThatNoStoresFound(additionalMessage: "User is in the Search Filter Map View")
            
        }
        
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

//MARK: Map View Delegate Code
extension FilterViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
            
        }
        
        let smallSquare = CGSize(width: 30, height: 30)
        let callOutViewButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        callOutViewButton.setBackgroundImage(UIImage(named: "carIcon"), for: .normal)
        
        let annotation = annotation as? CustomAnnotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation?.identifier)
        
        annotationView.canShowCallout = true
        annotationView.leftCalloutAccessoryView = callOutViewButton
        annotationView.image = blackNectarPin
        
        return annotationView
        
    }
    
}

//MARK: Gets Driving Directions Code
extension FilterViewController {
    
    
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
                .addBody("User navigated to \(storeName)\nstore coordinates: \(storeLocation.coordinate)\n(Search Filter Map View)")
                .withPriority(.medium)
                .send()
            
        }
        
    }
    
}

//MARK: Style Menu Code
extension FilterViewController {
    
    func styleButtonOn(button: UIButton) {
        
        let animations = {
            button.backgroundColor = Colors.fromRGB(red: 235, green: 191, blue: 77)
            button.titleLabel?.font = Fonts.oxygenBold
            
        }
        
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: animations, completion: nil)
        
    }
    
    func styleButtonOff(button: UIButton) {
        
        let animations = {
            button.backgroundColor = UIColor.clear
            button.titleLabel?.font = Fonts.oxygenRegular
        }
        
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: animations, completion: nil)
        
    }
    
}

//MARK: Aroma Messages
extension FilterViewController {
    
    func makeNoteThatNoStoresFound(additionalMessage: String = "") {
        
        LOG.warn("There are no stores around the users location: \(UserLocation.instance.currentLocation)")
        AromaClient.beginMessage(withTitle: "No stores loading result is 0")
            .addBody("Users location is: \(UserLocation.instance.currentLocation)\n (Stores loading result is 0 : \(additionalMessage)")
            .withPriority(.high)
            .send()
        
    }
    
    func userLocationInfoForAroma() {
        
        guard let userLocationForAroma = UserLocation.instance.currentCoordinate else { return }
        
        AromaClient.beginMessage(withTitle: "User Entered Map View (Search Filter)")
            .addBody("User Location is: \(userLocationForAroma)")
            .withPriority(.low)
            .send()
        
    }
    
}

