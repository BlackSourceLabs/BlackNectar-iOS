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
    
    func didUpdateFilter(_ : FilterViewController, farmersMarket: Bool, groceryStores: Bool, useMyLocation: Bool, useZipCode: Bool, zipCode: String?)
    
    func didDismissFilter(_ : FilterViewController, farmersMarkets: Bool, groceryStores: Bool, zipCode: String)
    
}

class FilterViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var farmersMarketsButton: UIButton!
    @IBOutlet weak var groceryStoresButton: UIButton!
    @IBOutlet weak var useMyLocationSwitch: UISwitch!
    @IBOutlet weak var useZipCodeSwitch: UISwitch!
    @IBOutlet weak var zipCodeButton: CustomButtonView!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    var didChangeFilterOptions = false
    var currentCoordinates: CLLocationCoordinate2D?
    
    var showFarmersMarkets: Bool {
        
        get {
            
            return UserPreferences.instance.showFarmersMarkets
        }
        
        set(newValue) {
            
            UserPreferences.instance.showFarmersMarkets = newValue
            styleFarmersMarkets()
            makeNoteThatUserUpdatedShowFarmersMarket(with: newValue)
            didChangeFilterOptions = true
        }
    }
    
    var showGroceryStores: Bool {
        
        get {
            
            return UserPreferences.instance.showStores
        }
        
        set(newValue) {
            
            UserPreferences.instance.showStores = newValue
            styleGroceryStores()
            makeNoteThatUserUpdatedShowStore(with: newValue)
            didChangeFilterOptions = true
        }
    }
    
    var useMyLocation: Bool {
        
        get {
            return UserPreferences.instance.useMyLocation
        }
        
        set(newValue) {
            
            UserPreferences.instance.useMyLocation = newValue
            UserPreferences.instance.useZipCode = !newValue
            self.styleLocationButtons()
            didChangeFilterOptions = true
        }
    }
    
    var useZipCode: Bool {
        
        get {
            
            return UserPreferences.instance.useZipCode
        }
        
        set(newValue) {
            
            UserPreferences.instance.useZipCode = newValue
            UserPreferences.instance.useMyLocation = !newValue
            self.styleLocationButtons()
            didChangeFilterOptions = true
            
        }
    }
    
    var zipCode: String {
        
        get {
            
            return UserPreferences.instance.zipCode ?? ""
        }
        
        set(newValue) {
            
            UserPreferences.instance.zipCode = newValue
            zipCodeButton.setTitle(newValue, for: .normal)
            didChangeFilterOptions = true
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleGroceryStores()
        styleFarmersMarkets()
        styleLocationButtons()
        styleZipCodeButton()
        
    }
    
    
    //MARK: Cancel Button Code
    @IBAction func didTapDismissButton(_ sender: UIBarButtonItem) {
        
        guard useZipCode || useMyLocation else {
            let alert = createAlertToSelectAnOption()
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if didChangeFilterOptions {
            
            self.delegate?.didUpdateFilter(self,
                                           farmersMarket: self.showFarmersMarkets,
                                           groceryStores: self.showGroceryStores,
                                           useMyLocation: self.useMyLocation,
                                           useZipCode: self.useZipCode,
                                           zipCode: self.zipCode)
            
        }
        else {
            
            self.delegate?.didDismissFilter(self,
                                            farmersMarkets: self.showFarmersMarkets,
                                            groceryStores: self.showGroceryStores,
                                            zipCode: self.zipCode)
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Map Button Code
    @IBAction func findMeButton(_ sender: UIButton) {
        
        if useMyLocation {
            
            let location = self.mapView.userLocation.coordinate
            centerMapAround(location: location)
            
        }
        else if useZipCode {
            
            askForUserLocation()
        }
    }
    
    //MARK: Filter Buttons Code
    @IBAction func onFarmersMarkets(_ sender: UIButton) {
        
        showFarmersMarkets = !showFarmersMarkets
        mapView.removeVisibleAnnotations()
        loadStores()
        
    }
    
    @IBAction func onGroceryStores(_ sender: UIButton) {
        
        showGroceryStores = !showGroceryStores
        mapView.removeVisibleAnnotations()
        loadStores()
        
    }
    
    @IBAction func zipCodeButtonTapped(_ sender: CustomButtonView) {
        
        if useZipCode {
            askForZipCode()
        }
    }
    
    //MARK: Location Switches
    @IBAction func onUseMyLocation(_ sender: UISwitch) {
        
        useMyLocation = !useMyLocation
        
        if useMyLocation {
            
            askForUserLocation()
            
        }
        else if useZipCode {
            
            refreshUsingZipCode()
            
        }
        else {
            
            askForLocationOrZipCode()
        }
        
    }
    
    @IBAction func onUseZipCode(_ sender: UISwitch) {
        
        useZipCode = !useZipCode
        
        if useZipCode {
            refreshUsingZipCode()
        }
        else if useMyLocation {
            
            self.askForUserLocation()
            
        }
        else { //Neither are set
            
            askForLocationOrZipCode()
            
        }
        
    }
    
    private func refreshUsingZipCode() {
        
        if zipCode.isEmpty {
            
            askForZipCode()
            
        }
        else {
            
            self.moveMapTo(zipCode: zipCode)
            
        }
    }
    
    private func askForLocationOrZipCode() {
        
        let alert = createAlertToSelectAnOption()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func askForUserLocation() {
        
        let alert = createAlertToRequestGPSPermissions()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func askForZipCode() {
        
        let alert = createAlertToGetZipCode()
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Loads Stores into Map View and when User Pans
extension FilterViewController {
    
    fileprivate func loadStores() {
        
        if useMyLocation {
            
            UserLocation.instance.requestLocation(callback: self.loadStoresInMapView)
        }
        else if useZipCode, zipCode.notEmpty {
            self.loadStoresInZipCode(at: zipCode)
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
        
        if useMyLocation, let userLocation = UserLocation.instance.currentLocation {
            
            self.centerMapAround(location: userLocation.coordinate)
            
        }
        else if useZipCode, zipCode.notEmpty {
            
            moveMapTo(zipCode: zipCode)
        }
        else {
            
            UserLocation.instance.requestLocation() { location in
                
                self.centerMapAround(location: location)
                
                self.useMyLocation = true
            }
        }
        
    }
    
    func centerMapAround(location: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: false)
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        self.currentCoordinates = center
        
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
            self.makeNoteThatLoadedStoresFromZipCode(stores: stores, zipCode: zipCode)
            
            self.main.addOperation {
                
                self.stopSpinningIndicator()
                self.populateStoreAnnotations()
            }
            
        }
        
    }
    
    func moveMapTo(zipCode: String) {
        
        ZipCodes.locationForZipCode(zipCode: zipCode) { location in
            
            guard let location = location else { return }
            self.centerMapAround(location: location)
            
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
    
    func createAlertToSelectAnOption() -> UIAlertController {
        
        let title = "Select An Option"
        let message = "You must select at least one option. We need a location to find EBT stores around you."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let myLocationOption = UIAlertAction(title: "Use My Location", style: .default) { _ in
            let alert = self.createAlertToRequestGPSPermissions()
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let zipCodeOption = UIAlertAction(title: "Use Zip Code", style: .default) { _ in
            let alert = self.createAlertToGetZipCode()
            self.present(alert, animated: true, completion: nil)
            
        }
        
        controller.addAction(myLocationOption)
        controller.addAction(zipCodeOption)
        
        return controller
    }
    
    func createAlertToRequestGPSPermissions() -> UIAlertController {
        
        let title = "Requesting GPS Access"
        let message = "By granting us access, we can find EBT stores around you."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            if self.zipCode.notEmpty {
                self.useZipCode = true
                return
            }
            else {
            
                let alert = self.createAlertToSelectAnOption()
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            self.requestGPSAccess()
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        
        return controller
    }
    
    func createAlertToGetZipCode() -> UIAlertController {
        
        let title = "Enter Zip Code"
        let message = "Please enter a valid zip code.(eg - 90401)"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            if !self.useZipCode {
                let alert = self.createAlertToSelectAnOption()
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        let go = UIAlertAction(title: "Go", style: .default) { _ in
            
            guard let zipCode = controller.textFields?.first?.text, zipCode.notEmpty else {
                
                self.makeNoteThatNoZipCodeEntered()
                let warning = self.createAlertToWarnOfInvalidZip(zip: "")
                self.present(warning, animated: true, completion: nil)
                
                return
            }
            
            self.moveMapTo(zipCode: zipCode)
            self.loadStoresInZipCode(at: zipCode)
            self.zipCode = zipCode
            self.useZipCode = true
            self.useMyLocation = false
            self.styleZipCodeButton()
        }
        
        controller.addAction(cancel)
        controller.addAction(go)
        
        controller.addTextField() { zipCode in
            zipCode.placeholder = "(eg - 10455)"
            zipCode.keyboardType = .numberPad
        }
        
        return controller
    }
    
    func createAlertToWarnOfInvalidZip(zip: String) -> UIAlertController {
        
        let title = "Invalid Zip Code."
        let message = "Please enter a valid zip code"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.useZipCode = false
            
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let newAlert = self.createAlertToGetZipCode()
            
            self.present(newAlert, animated: true, completion: nil)
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        
        return controller
    }
    
    func createAlertToSendUserToSettings() -> UIAlertController {
        
        let title = "Requesting GPS Access"
        let message = "Please go to \"Location\" and enable \"While Using the App\""
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let openSettings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.senduserToSettings()
        }
        
        controller.addAction(openSettings)
        
        return controller
    }
    
    func requestGPSAccess() {
        
        if let status = UserLocation.instance.currentStatus, status == .denied {
            
            let alert = createAlertToSendUserToSettings()
            self.present(alert, animated: true, completion: nil)
            useMyLocation = false
            return
        }
        
        UserLocation.instance.requestLocation() { location in
            
            self.useMyLocation = true
            self.loadStoresInMapView(at: location)
            self.centerMapAround(location: location)
            
        }
    }
    
    private func senduserToSettings() {
        
        let link = UIApplicationOpenSettingsURLString
        
        guard let url = URL(string: link) else {
            LOG.error("Failed to create URL to \(link)")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}

//MARK: Style Menu Code
fileprivate extension FilterViewController {
    
    func styleButtonOn(button: UIButton) {
        
        let animations = {
            
            button.setTitleColor(Colors.darkSecondary, for: .normal)
            button.backgroundColor = Colors.primaryAccent
            
        }
        
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: animations, completion: nil)
        
    }
    
    func styleButtonOff(button: UIButton) {
        
        let animations = {
            
            button.setTitleColor(Colors.white, for: .normal)
            button.backgroundColor = UIColor.clear
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
        styleMyLocationButton()
        styleZipCodeButton()
    }
    
    func styleMyLocationButton() {
        useMyLocationSwitch.isOn = useMyLocation
    }
    
    func styleZipCodeButton() {
        
        useZipCodeSwitch.isOn = useZipCode
        
        if useZipCode, zipCode.notEmpty {
            
            zipCodeLabel.text? = "Zip Code: "
            zipCodeButton.isHidden = false
            zipCodeButton.setTitle(zipCode, for: .normal)
        }
        else {
            zipCodeLabel.text? = "Use Zip Code"
            zipCodeButton.isHidden = true
        }
        
    }
    
}

//MARK: Aroma Messages
fileprivate extension FilterViewController {
    
    func makeNoteThatNoStoresFound(additionalMessage: String = "") {
        
        LOG.warn("There are no stores around: \(self.mapView.centerCoordinate)")
        
        AromaClient.beginMessage(withTitle: "No Stores Loaded")
            .addBody("No stores were found in the FilterViewController at: \(self.mapView.centerCoordinate)")
            .withPriority(.high)
            .send()
        
    }
    
    func makeNoteThatUserUpdatedShowStore(with value: Bool) {
        
        LOG.debug("User updated showStores with: \(value)")
        
        AromaClient.beginMessage(withTitle: "User Updated Filter")
            .addBody("Show Stores: \(value)")
            .withPriority(.low)
            .send()
        
    }
    
    func makeNoteThatUserUpdatedShowFarmersMarket(with value: Bool) {
        
        LOG.debug("User updated showFarmersMarket with: \(value)")
        
        AromaClient.beginMessage(withTitle: "User Updated Filter")
            .addBody("Show Farmers Markets: \(value)")
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
    
    func makeNoteThatLoadedStoresFromZipCode(stores: [Store], zipCode: String) {
        
        let message = "Loaded \(stores.count) stores from Zip Code [\(zipCode)]"
        LOG.info(message)
        AromaClient.sendLowPriorityMessage(withTitle: "Loaded Store From Zip Code", withBody: message)
    }
    
}

