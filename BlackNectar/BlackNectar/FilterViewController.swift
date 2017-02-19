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
    
    func didSelectFilters(_ : FilterViewController, farmersMarkets: Bool, groceryStores: Bool)
    
}

class FilterViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var farmersMarketsButton: UIButton!
    @IBOutlet weak var groceryStoresButton: UIButton!
    @IBOutlet weak var useMyLocationSwitch: UISwitch!
    @IBOutlet weak var useZipeCodeSwitch: UISwitch!
    
    
    var currentCoordinates: CLLocationCoordinate2D?
    
    var showFarmersMarkets: Bool {
        
        get {
            
            return UserPreferences.instance.showFarmersMarkets
        }
        
        set(newValue) {
            
            UserPreferences.instance.showFarmersMarkets = newValue
        }
        
    }
    
    var showGroceryStores: Bool {
        
        get {
            
            return UserPreferences.instance.showStores
        }
        
        set(newValue) {
            
            UserPreferences.instance.showStores = newValue
        }
        
    }
    
    var useMyLocation: Bool {
        
        get {
            
            return UserPreferences.instance.useMyLocation
        }
        
        set(newValue) {
            
            UserPreferences.instance.useMyLocation = newValue
            styleLocationButtons()
        }
    }
    
    var useZipCode: Bool {
        
        get {
            
            return UserPreferences.instance.useZipCode
        }
        
        set(newValue){
            
            UserPreferences.instance.useZipCode = newValue
            styleLocationButtons()
        }
        
    }
    
    var delegate: FilterDelegate?
    var distance = 0.0
    
    var stores: [Store] = []
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleGroceryStores()
        styleFarmersMarkets()
        styleLocationButtons()
    }
    
    
    //MARK: Cancel Button Code
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        self.delegate?.didSelectFilters(self, farmersMarkets: self.showFarmersMarkets, groceryStores: self.showGroceryStores)
        self.dismiss(animated: true, completion: nil)
        
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
    
    //MARK: Location Switches
    @IBAction func onMyLocation(_ sender: UISwitch) {
        
        useMyLocation = !useMyLocation
        useZipCode = !useMyLocation
    }
    
    @IBAction func onUseZipeCode(_ sender: UISwitch) {
        
        useZipCode = !useZipCode
        useMyLocation = !useZipCode
        
        if useZipCode {
            askForZipCode()
        }
    }
    
    private func askForZipCode() {
        
        let alert = createAlertToGetZipCode()
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Loads Stores into Map View and when User Pans
extension FilterViewController {
    
    fileprivate func loadStores() {
        
        UserLocation.instance.requestLocation { coordinate in
            
            self.loadStoresInMapView(at: coordinate)
            
        }
        
    }
    
    func loadStoresInMapView(at coordinate: CLLocationCoordinate2D) {
        
        startSpinningIndicator()
        
        SearchStores.searchForStoresLocations(near: coordinate) { stores in
            
            self.stores = self.filterStores(from: stores)
            
            self.main.addOperation {
                
                self.populateStoreAnnotations()
                self.stopSpinningIndicator()
                
            }
            
        }
        
        if self.stores.isEmpty {
            
            self.makeNoteThatNoStoresFound(additionalMessage: "User is in the Filter Map View")
            
        }
        
    }
    
    fileprivate func filterStores(from stores: [Store]) -> [Store] {
        
        if showFarmersMarkets == showGroceryStores {
            return stores
        }
        
        if showGroceryStores {
            return stores.filter() { $0.notFarmersMarket }
        }
        
        if showFarmersMarkets {
            return stores.filter() { $0.isFarmersMarket }
        }
        
        return stores
        
    }
    
    func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        guard let region = UserLocation.instance.currentRegion else {
            
            LOG.error("Failed to load the Users Current Region")
            return
        }
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        
        LOG.debug("User dragged Map Screen to: \(center)")
        
        self.loadStoresInMapView(at: center)
        
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

//MARK: Zip Code

fileprivate extension FilterViewController {
    
    func loadStoresInZipCode(at zipCode: String) {
        
        startSpinningIndicator()
        
        SearchStores.searchForStoresByZipCode(withZipCode: zipCode) { (stores) in
            
            self.stores = self.filterStores(from: stores)
            
            self.main.addOperation {
                
                self.stopSpinningIndicator()
                self.populateStoreAnnotations()
                
            }
            
        }
        
    }
    
    func calculateRegionForMapView(withZipCode zipCode: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            
            if let error = error {
                self.makeNoteThatGeoCodingFailed(zipCode: zipCode, error: error)
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                
                self.mapView?.setCenter(location.coordinate, animated: true)
            }
            
        }
        
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

//MARK: Create Alert Views
fileprivate extension FilterViewController {
    
    func createAlertToGetZipCode() -> UIAlertController {
        
        let title = "Enter Zip Code"
        let message = "Please enter a valid zip code.(eg - 90401)"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let go = UIAlertAction(title: "Go", style: .default) { _ in
            
            guard let zipCode = controller.textFields?.first?.text, zipCode.notEmpty else {
                
                self.makeNoteThatNoZipCodeEntered()
                let warning = self.createAlertToWarnOfInvalidZip(zip: "")
                self.present(warning, animated: true, completion: nil)
                
                return
            }
            
            self.calculateRegionForMapView(withZipCode: zipCode)
            self.loadStoresInZipCode(at: zipCode)
        }
        
        controller.addAction(cancel)
        controller.addAction(go)
        controller.addTextField() { zipCode in
            zipCode.placeholder = "(eg - 10455)"
        }
        
        return controller
    }
    
    func createAlertToWarnOfInvalidZip(zip: String) -> UIAlertController {
        
        let title = "Invalid Zip Code."
        let message = "Please enter a valid zip code"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let newAlert = self.createAlertToGetZipCode()
            
            self.present(newAlert, animated: true, completion: nil)
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        
        return controller
    }
}

//MARK: Style Menu Code
fileprivate extension FilterViewController {
    
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
    
    func styleFarmersMarkets() {
        
        if showFarmersMarkets {
            
            styleButtonOn(button: farmersMarketsButton)
            
        } else {
            
            styleButtonOff(button: farmersMarketsButton)
            
        }
        
    }
    
    func styleGroceryStores() {
        
        if showGroceryStores {
            
            styleButtonOn(button: groceryStoresButton)
            
        } else {
            
            styleButtonOff(button: groceryStoresButton)
            
        }
        
    }
    
    func styleLocationButtons() {
        useMyLocationSwitch.isOn = useMyLocation
        useZipeCodeSwitch.isOn = useZipCode
        
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
    
    func makeNoteThatNoZipCodeEntered() {
        
        let message = "The user entered an empty zip code"
        LOG.info(message)
        AromaClient.beginMessage(withTitle: "Invalid Zip Code")
            .addBody(message)
            .withPriority(.medium)
            .send()
    }
    
    func makeNoteThatGeoCodingFailed(zipCode: String, error: Error) {
        
        let message = "Failed to reverse-geocode ZipCode [\(zipCode)]. | \(error)"
        
        LOG.error(message)
        AromaClient.sendHighPriorityMessage(withTitle: "ZipCode Geocode Failed", withBody: message)
    }
    
}

