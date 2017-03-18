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
import MessageUI
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
    
    var isFirstTimeUser: Bool {
        
        get {
            
            return UserPreferences.instance.isFirstTimeUser
        }
        
        set(newValue) {
            
            UserPreferences.instance.isFirstTimeUser = newValue
        }
    }
    
    var stores: [Store] = []
    let mailComposeViewController = MFMailComposeViewController()
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
        
    }()
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        if isFirstTimeUser {
            goToWelcomeScreen()
        }
        else {
            UserLocation.instance.initialize()
            reloadStoreData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

//MARK: Welcome Screen Code
extension StoresTableViewController: WelcomeScreenDelegate {
    
    func goToWelcomeScreen() {
        
        performSegue(withIdentifier: "toWelcome", sender: nil)
    }
    
    func didDismissWelcomeScreens() {
        
        isFirstTimeUser = false
        self.reloadStoreData()
    }
    
}

//MARK: Table View Code
extension StoresTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.notEmpty ? stores.count : 1
        
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
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        guard tableView.cellForRow(at: indexPath) is StoresTableViewCell else { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? StoresTableViewCell else { return }
        cell.contentView.backgroundColor = Colors.from(hexString: "ECC040")
        
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        guard tableView.cellForRow(at: indexPath) is StoresTableViewCell else { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = UIColor.clear
        
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

//MARK: Mail Code
extension StoresTableViewController: MFMailComposeViewControllerDelegate {
    
    fileprivate func sendEmail() {
        
        if !MFMailComposeViewController.canSendMail() {
            
            makeNoteThatUserHasMailSettingsDisabled()
            
        } else {
            
            self.present(configureMailComposeViewController(), animated: true, completion: nil)
            
        }
        
    }
    
    fileprivate func configureMailComposeViewController() -> MFMailComposeViewController {
        
        mailComposeViewController.mailComposeDelegate = self
        
        mailComposeViewController.setToRecipients(["feedback@blacksource.tech"])
        mailComposeViewController.setSubject("We love feeback - Place your comment below")
        mailComposeViewController.setMessageBody("We are open to all feedback. Let us know if there are no stores in your area that accept EBT.", isHTML: false)
        
        return mailComposeViewController
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error {
            
            makeNoteThatSendingEmailFailed(withError: "\(error)")
            sendEmailErrorAlert()
            return
            
        }
        
        makeNoteThatUserFinishedEmail(withResult: "\(result)")
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK: Alert View Code
fileprivate extension StoresTableViewController {
    
    fileprivate func sendEmailErrorAlert() {
        
        let alert = createAlertForEmailError()
        self.presentAlert(alert)
        
    }
    
    fileprivate func createAlertForEmailError() -> UIAlertController {
        
        let title = "Sending Email Failed"
        let message = "Your device did not successfully send the Email. Please check your wi-fi settings or signal strength and try again."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            self.present(self.configureMailComposeViewController(), animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(ok)
        controller.addAction(cancel)
        
        return controller
        
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

//MARK: Segue Code
extension StoresTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? UINavigationController {
            
            let storesMapViewController = destination.topViewController as? StoresMapViewController
            storesMapViewController?.stores = self.stores
            
        }
        
        if let destination = segue.destination as? UINavigationController,
            let filterViewController = destination.topViewController as? FilterViewController {
            
            filterViewController.delegate = self
            
        }
        
        if let destination = segue.destination as? UINavigationController,
            let welcomeScreen = destination.topViewController as? WelcomeScreenOne {
            
            welcomeScreen.delegate = self
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
    
    func makeNoteThatUserFinishedEmail(withResult result: String) {
        
        LOG.info("Email Result is: \(result)")
        AromaClient.beginMessage(withTitle: "User Finished Email with: \(result)")
            .addBody("Finished Email: (\(result))")
            .withPriority(.low)
            .send()
        
    }
    
    func makeNoteThatSendingEmailFailed(withError error: String) {
        
        LOG.error("There was an error with the email: \(error)")
        AromaClient.beginMessage(withTitle: "There was an error with the email: \(error)")
            .addBody("Email Error is: \(error)")
            .withPriority(.medium)
            .send()
        
    }
    
    func makeNoteThatSendingUserToSettingsForMail() {
        
        let message = "Sending User to 'Settings' so they can enable Mail Services"
        AromaClient.sendMediumPriorityMessage(withTitle: "Sending User To Settings", withBody: message)
        
    }
    
    func makeNoteThatUserHasMailSettingsDisabled() {
        
        LOG.error("User has mail settings disabled")
        AromaClient.beginMessage(withTitle: "User has mail settings disabled")
            .addBody("User has mail settings disabled or doesn't have an account")
            .withPriority(.medium)
            .send()
        
    }
    
}


