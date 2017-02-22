//
//  StoresTableViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import CoreLocation
import Foundation
import Kingfisher
import MapKit
import UIKit

class StoresTableViewController: UITableViewController, FilterDelegate, UIGestureRecognizerDelegate {
    
    var showFarmersMarkets: Bool {
        return UserPreferences.instance.showFarmersMarkets
    }
    
    var showStores: Bool {
        return UserPreferences.instance.showStores
    }
    
    var useMyLocation: Bool {
        return UserPreferences.instance.useMyLocation
    }
    
    var useZipCode: Bool {
        return UserPreferences.instance.useZipCode
    }
    
    var zipCode: String {
        return UserPreferences.instance.zipCode ?? ""
    }
    
    var stores: [Store] = []
    var panningWasTriggered = false
    let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
        
    }()
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation.instance.initialize()
        setupRefreshControl()
        reloadStoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setEdgeGesture()
        
    }
    
}

//MARK: Filter Delegate Code
extension StoresTableViewController {
    
    func didDismissFilter(_: FilterViewController, farmersMarkets: Bool, groceryStores: Bool, zipCode: String) {
        
    }
    
    func didUpdateFilter(_: FilterViewController, farmersMarket: Bool, groceryStores: Bool, useMyLocation: Bool, useZipCode: Bool, zipCode: String?) {
        
        reloadStoreData()
        
    }
    
}

//MARK: Table View Code
extension StoresTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as? StoresTableViewCell else {
            
            LOG.error("Failed to dequeue StoresTableViewCell")
            return UITableViewCell()
            
        }
        
        let row = indexPath.row
        
        guard stores.isInBounds(index: row) else {
            LOG.warn("Received Out of Bounds Index: \(row)")
            return cell
        }
        
        let store = stores[row]
        
        insertDistance(toStore: store, into: cell)
        goLoadImage(into: cell, withStore: store.storeImage)
        insertAddress(into: cell, withStore: store)
        
        cell.storeName.text = store.storeName
        cell.onGoButtonPressed = { cell in
            
            self.navigateWithDrivingDirections(toStore: store)
            self.makeNoteThatUserTapped(on: store)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard stores.notEmpty else { return }
        guard tableView.cellForRow(at: indexPath) is StoresTableViewCell else { return }
        
        let index = indexPath.row
        guard stores.isInBounds(index: index) else { return }
        
        let store = stores[index]
        self.navigateWithDrivingDirections(toStore: store)
        self.makeNoteThatUserTapped(on: store)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cellAnimation = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.alpha = 0
        cell.layer.transform = cellAnimation
        
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
            
        }
        
    }
    
    private func goLoadImage(into cell: StoresTableViewCell, withStore url: URL) {
        
        let fade = KingfisherOptionsInfoItem.transition(.fade(0.5))
        let scale = KingfisherOptionsInfoItem.scaleFactor(UIScreen.main.scale * 2)
        let options: KingfisherOptionsInfo = [fade, scale]
        
        cell.storeImage.kf.setImage(with: url, placeholder: nil, options: options, progressBlock: nil, completionHandler: nil)
        
    }
    
    private func insertAddress(into cell: StoresTableViewCell, withStore store: Store) {
        
        let street = store.address.addressLineOne
        let city = store.address.city
        let state = store.address.state
        
        cell.storeAddress.text = street + "\n" + city + ", " + state
        
    }
    
    private func insertDistance(toStore store: Store, into cell: StoresTableViewCell) {
        
        guard !useZipCode else {
            cell.storeDistance.isHidden = true
            return
        }
        
        
        if let currentLocation = UserLocation.instance.currentCoordinate {
            
            var distance = 0.0
            distance = DistanceCalculation.getDistance(userLocation: currentLocation, storeLocation: store.location)
            distance = DistanceCalculation.metersToMiles(meters: distance)
            let doubleDown = Double(round(distance * 100)/100)
            
            cell.storeDistance.isHidden = false
            cell.storeDistance.text = "\(doubleDown) miles"

        }
        
    }
    
}

//MARK: Refresh Code
extension StoresTableViewController {
    
    func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor .init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1)
        
        refreshControl?.addTarget(self, action: #selector(self.reloadStoreData), for: .valueChanged)
        
    }
   
    
    func reloadStoreData() {
        
        if useMyLocation {

            UserLocation.instance.requestLocation(callback: self.loadStores)
        }
        else if useZipCode, zipCode.notEmpty {
            
            loadStores(atZipCode: zipCode)
            
        }
        else {
            //GoToFilter
            self.goToFilters()
        }
        
    }
    
    func loadStores(atZipCode zipCode: String) {
        
        startSpinningIndicator()
        SearchStores.searchForStoresByZipCode(withZipCode: zipCode, callback: self.populateStores)
        
    }
    
    func loadStores(atCoordinate coordinate: CLLocationCoordinate2D) {
        
        startSpinningIndicator()
        SearchStores.searchForStoresLocations(near: coordinate, callback: self.populateStores)
        
    }
    
    private func populateStores(stores: [Store]) {
        
        self.stores = self.filterStores(from: stores)
        
        self.main.addOperation {
            
            self.reloadSection(0)
            self.stopSpinningIndicator()
            self.refreshControl?.endRefreshing()
        }
        
        if self.stores.isEmpty {
            
            self.makeNoteThatNoStoresFound(additionalMessage: "User is in Stores Table View")
            
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
    
}

//MARK: Navigation Code
extension StoresTableViewController {
    
    internal func navigateWithDrivingDirections(toStore store: Store) {
        
        let appleMapsLaunchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeKey]
        
        let storePlacemark = MKPlacemark(coordinate: store.location, addressDictionary: ["\(title)" : store.storeName])
        let storePin = MKMapItem(placemark: storePlacemark)
        storePin.name = store.storeName
        
        storePin.openInMaps(launchOptions: appleMapsLaunchOptions)
        
    }
    
}

//MARK: Prepare and Perform Segue Code
extension StoresTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? StoresMapViewController {
            
            destination.stores = self.stores
            
        }
        
        if let destination = segue.destination as? UINavigationController {
            
            let filterViewController = destination.topViewController as? FilterViewController
            filterViewController?.delegate = self
            
        }
        
    }
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        
        goToMapView()
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        goToFilters()
        
    }
    
    func goToFilters() {
        
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
    
    func goToMapView() {
        performSegue(withIdentifier: "mapViewSegue", sender: nil)
    }
    
}

//MARK: UI Screen Pan Gesture Code
extension StoresTableViewController {
    
    func setEdgeGesture() {
        
        edgePanGestureRecognizer.addTarget(self, action: #selector(self.handleRightEdge(gesture:)))
        edgePanGestureRecognizer.edges = .right
        edgePanGestureRecognizer.delegate = self
        
        self.view.addGestureRecognizer(edgePanGestureRecognizer)
        
    }
    
    func handleRightEdge(gesture: UIScreenEdgePanGestureRecognizer) {
        
        switch gesture.state {
            
            case .began, .changed:
                setGestureProperties()
                
            case .cancelled, .failed:
                panningWasTriggered = false
                
            default: break
            
        }
        
    }
    
    func setGestureProperties() {
        
        if !panningWasTriggered {
            
            let threshold: CGFloat = 30
            let translation = abs(edgePanGestureRecognizer.translation(in: view).x)
            
            if translation >= threshold {
                
                performSegue(withIdentifier: "mapViewSegue", sender: nil)
                
                panningWasTriggered = true
                
            }
            
        }
        
    }
    
}

//MARK: Aroma Messages Code
fileprivate extension StoresTableViewController {
    
    
    func makeNoteThatNoStoresFound(additionalMessage: String = "") {
        
        LOG.warn("There are no stores around the users location")
        AromaClient.beginMessage(withTitle: "No stores loading result is 0")
            .addBody("Users location is: \(UserLocation.instance.currentLocation)\n (Stores loading result is 0 : \(additionalMessage)")
            .withPriority(.high)
            .send()
        
    }
    
    func makeNoteThatFilterMenuOpened() {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Filter Opened")
        LOG.debug("Filter Opened")
        
    }
    
    func makeNoteThatFilterMenuCancelled() {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Filter Cancelled")
        LOG.debug("Cancelling Filter")
        
    }
    
    func makeNoteThatUserTapped(on store: Store) {
        
        LOG.debug("User tapped on Store: \(store)")
        
        AromaClient.beginMessage(withTitle: "User Tapped On Store ")
            .addBody("From the StoresTableViewController").addLine(2)
            .addBody("User navigated to \(store.storeName)\n\n\(store)")
            .withPriority(.medium)
            .send()
    }
    
}


