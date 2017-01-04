//
//  StoresTableViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import CoreLocation
import Foundation
import Kingfisher
import SWRevealController
import UIKit


//TODO: Integrate with Carthage

class StoresTableViewController: UITableViewController, SideMenuFilterDelegate {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    
    var stores: [StoresInfo] = []
    var distanceFilter = 0.0
    var showRestaurants = false
    var showStores = false
    var onlyShowOpenStores = true
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10

        return operationQueue
        
    }()
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation.instance.initialize()
        configureSlideMenu()
        setupRefreshControl()
        
        if let currentLocation = UserLocation.instance.currentCoordinate {
            
            loadStores(at: currentLocation)
            
        } else {
            
            
            UserLocation.instance.requestLocation() { coordinate in
                self.loadStores(at: coordinate)
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFilterTapped(_ sender: Any) {
        
        if let revealController = self.revealViewController() {
            revealController.revealToggle(animated: true)
        }

    }
    
    func didApplyFilters(_ filter: SideMenuFilterViewController, restaurants: Bool, stores: Bool, openNow: Bool, distanceInMiles: Int) {
        
        showRestaurants = restaurants
        showStores = stores
        onlyShowOpenStores = openNow
        distanceFilter = DistanceCalculation().milesToMeters(miles: Double(distanceInMiles))
        
        if let currentLocation = UserLocation.instance.currentCoordinate {
            
            loadStores(at: currentLocation)
            
        }
                
    }
    
    func didCancelFilters() {
        print("onCancel func hit")
        dismiss(animated: true, completion: nil)
    }
    
    private func loadStores(at coordinate: CLLocationCoordinate2D) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchStores.searchForStoresLocations(near: coordinate, with: distanceFilter) { stores in
            self.stores = stores
            
            self.main.addOperation {
                
                self.tableView.reloadData()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
            
        }
        
    }
    
    
    fileprivate func configureSlideMenu() {
        
        guard let menu = self.revealViewController() else { return }
        
        if let gesture = menu.panGestureRecognizer() {
            
             self.view.addGestureRecognizer(gesture)
            
        }
        
        guard let sideMenu = menu.rearViewController as? SideMenuFilterViewController else { return }
        
        sideMenu.delegate = self
        
    }
    
    func goLoadImage(into cell: StoresTableViewCell, withStore url: URL) {
        
        let fade = KingfisherOptionsInfoItem.transition(.fade(0.5))
        let scale = KingfisherOptionsInfoItem.scaleFactor(UIScreen.main.scale * 2)
        let options: KingfisherOptionsInfo = [fade, scale]
        
        cell.storeImage.kf.setImage(with: url, placeholder: nil, options: options, progressBlock: nil, completionHandler: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapViewSegue" {
            
            if let destination = segue.destination as? StoresMapViewController {
            
                destination.distance = distanceFilter
                destination.onlyShowOpenStores = self.onlyShowOpenStores
                destination.showRestaurants = self.showRestaurants
                destination.showStores = self.showStores
                
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as? StoresTableViewCell else {
            return UITableViewCell()
        }
        
        let store = stores[indexPath.row]
        var addressString = ""
        if let currentLocation = UserLocation.instance.currentCoordinate {

            var distance = 0.0
            distance = DistanceCalculation().getDistance(userLocation: currentLocation, storeLocation: store.location)
            distance = DistanceCalculation().meteresToMiles(meters: distance)
            let doubleDown = Double(round(distance * 100)/100)
            
            cell.storeDistance.text = "\(doubleDown) miles"
        }
        
        //WTF IS THIS? FUNCTION PLEASE
        //Call it, combine addresses
        //PLEASE 🙏🏽
        addressString = (store.address["address_line_1"] as? String)! + "\n" + (store.address["city"] as? String)! + ", " + (store.address["state"] as? String)!
        
        goLoadImage(into: cell, withStore: store.storeImage)
        cell.storeName.text = store.storeName
        cell.storeAddress.text = addressString

        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cellAnimation = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.alpha = 0
        
        self.main.addOperation {
            
            cell.layer.transform = cellAnimation
            
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
                
            }
            
        }
        
    }
    
}

extension StoresTableViewController {
    
    func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1)
        
        self.isRefreshAnimating = true
        
        refreshControl?.addTarget(self, action: #selector(self.reloadStoreData), for: .valueChanged)
        
    }
    
    
    func reloadStoreData() {
        
        guard let usersLocation = UserLocation.instance.currentCoordinate else { return }
        let usersLatitude = usersLocation.latitude
        let usersLongitude = usersLocation.longitude
        
        SearchStores.searchForStoresLocations(near: usersLocation) { stores in
            self.stores = stores
            
            self.main.addOperation {
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
            }
            
        }
    
    }
    
}
