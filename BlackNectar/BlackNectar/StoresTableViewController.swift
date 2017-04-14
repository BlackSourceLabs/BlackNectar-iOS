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

//MARK: Filter Delegate 
extension StoresTableViewController {
    
    func didDismissFilter(_: FilterViewController, farmersMarkets: Bool, groceryStores: Bool, zipCode: String) {
        
    }
    
    func didUpdateFilter(_: FilterViewController, farmersMarket: Bool, groceryStores: Bool, useMyLocation: Bool, useZipCode: Bool, zipCode: String?) {
        
        reloadStoreData()
        
    }
    
}

//MARK: Welcome Screen
extension StoresTableViewController: WelcomeScreenDelegate {
    
    func goToWelcomeScreen() {
        
        performSegue(withIdentifier: "toWelcome", sender: nil)
    }
    
    func didDismissWelcomeScreens() {
        
        isFirstTimeUser = false
        self.reloadStoreData()
    }
    
}

//MARK: Table View
extension StoresTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.notEmpty ? stores.count : 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if stores.isEmpty {
            
            return createNoResultsCell(with: tableView, at: indexPath)
            
        }
        
        return createStoreCell(with: tableView, at: indexPath)
        
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
        
        guard stores.notEmpty else { return }
        
        let cellAnimation = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.alpha = 0
        cell.layer.transform = cellAnimation
        
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
            
        }
        
    }
    
    fileprivate func createStoreCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 200
        
        guard let storeCell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as? StoresTableViewCell else {
            
            makeNoteThatCellFailedToDequeue(cell: "StoresTableViewCell")
            return UITableViewCell()
            
        }
        
        let row = indexPath.row
        
        guard stores.isInBounds(index: row) else {
            LOG.warn("Received Out of Bounds Index: \(row)")
            return storeCell
        }
        
        let store = stores[row]
        
        insertDistance(toStore: store, into: storeCell)
        goLoadImage(into: storeCell, withStore: store.storeImage)
        insertAddress(into: storeCell, withStore: store)
        
        storeCell.storeName.text = store.storeName
        storeCell.onGoButtonPressed = { [weak self] cell in
            
            self?.navigateWithDrivingDirections(toStore: store)
            self?.makeNoteThatUserTapped(on: store)
        }
        
        return storeCell
        
    }
    
    fileprivate func createNoResultsCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height
        
        guard let noResultsCell = tableView.dequeueReusableCell(withIdentifier: "noResultsCell") as? NoResultsCustomCell else {
            
            makeNoteThatCellFailedToDequeue(cell: "NoResultsCustomCell")
            return UITableViewCell()
            
        }
        
        checkIfUserHasAnEmail(whenIn: noResultsCell)
        noResultsCell.onEmailButtonPressed = { [weak self] noResultsCell in
            
            self?.sendEmail()
            
        }
        
        return noResultsCell
        
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

//MARK: Send E-Mail
extension StoresTableViewController: MFMailComposeViewControllerDelegate {
    
    fileprivate func sendEmail() {
        
        if !MFMailComposeViewController.canSendMail() {
            
            return
            
        }
        else {
            
            self.present(configureMailComposeViewController(), animated: true, completion: nil)
            
        }
        
    }
    
    fileprivate func checkIfUserHasAnEmail(whenIn noResultsCell: NoResultsCustomCell) {
        
        if !MFMailComposeViewController.canSendMail() {
            
            noResultsCell.knowOfAnyLabel.isHidden = true
            noResultsCell.letUsKnowButton.isHidden = true
            
        }
        else {
            
            noResultsCell.knowOfAnyLabel.isHidden = false
            noResultsCell.letUsKnowButton.isHidden = false
            
        }
        
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeViewController = MFMailComposeViewController()
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

//MARK: Refresh/Load Stores
extension StoresTableViewController {
    
    func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.clear
        
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
        
        startSpinningNVActivityIndicator()
        SearchStores.searchForStoresByZipCode(withZipCode: zipCode, callback: self.populateStores)
        
    }
    
    func loadStores(atCoordinate coordinate: CLLocationCoordinate2D) {
        
        startSpinningNVActivityIndicator()
        SearchStores.searchForStoresLocations(near: coordinate, callback: self.populateStores)
        
    }
    
    private func populateStores(stores: [Store]) {
        
        self.stores = self.filterStores(from: stores)
        
        self.main.addOperation {
            
            let animation: UITableViewRowAnimation = stores.isEmpty ? .fade : .automatic
            self.reloadSection(0, animation: animation)
            
            self.stopSpinningNVActivityIndicator()
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

//MARK: Driving Navigation
extension StoresTableViewController {
    
    internal func navigateWithDrivingDirections(toStore store: Store) {
        
        let appleMapsLaunchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeKey]
        
        let storePlacemark = MKPlacemark(coordinate: store.location, addressDictionary: ["\(title ?? "")" : store.storeName])
        let storePin = MKMapItem(placemark: storePlacemark)
        storePin.name = store.storeName
        
        storePin.openInMaps(launchOptions: appleMapsLaunchOptions)
        
    }
    
}

//MARK: Segues
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
    
    @IBAction func didTapMapButton(_ sender: Any) {
        
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

//MARK: Aroma Messages
fileprivate extension StoresTableViewController {
    
    
    func makeNoteThatNoStoresFound(additionalMessage: String = "") {
        
        LOG.warn("There are no stores around the users location")
        AromaClient.beginMessage(withTitle: "No stores loading result is 0")
            .addBody("Users location is: \(UserLocation.instance.currentLocation?.description ?? "")\n (Stores loading result is 0 : \(additionalMessage)")
            .withPriority(.high)
            .send()
        
    }
    
    func makeNoteThatFilterMenuOpened() {
        
        LOG.debug("Filter Opened")
        AromaClient.sendLowPriorityMessage(withTitle: "Filter Opened")
        
    }
    
    func makeNoteThatFilterMenuCancelled() {
        
        LOG.debug("Cancelling Filter")
        AromaClient.sendLowPriorityMessage(withTitle: "Filter Cancelled")
        
    }
    
    func makeNoteThatUserTapped(on store: Store) {
        
        LOG.debug("User tapped on Store: \(store)")
        
        AromaClient.beginMessage(withTitle: "User Tapped On Store ")
            .addBody("From the StoresTableViewController").addLine(2)
            .addBody("User navigated to \(store.storeName)\n\n\(store)")
            .withPriority(.medium)
            .send()
        
    }
    
    func makeNoteThatCellFailedToDequeue(cell: String) {
        
        LOG.error("Failed to dequeue \(cell)")
        AromaClient.beginMessage(withTitle: "Failed to dequeue \(cell)")
            .addBody("Failed to dequeue \(cell)")
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
            .withPriority(.low)
            .send()
        
    }
    
}
