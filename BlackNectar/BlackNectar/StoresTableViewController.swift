//
//  StoresTableViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/28/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SWRevealController


class StoresTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var filterButton: UIButton!
    
    var stores: [StoresInfo] = []
    var currentLocation = UserLocation().prepareForLocation()
    var filterDelegate = SideMenuFilterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation().prepareForLocation()
        SearchStores.searchForStoresLocations(near: currentLocation) { stores in
            self.stores = stores
            print("TableViewController, stores is : \(self.stores)")
            self.tableView.reloadData()
            }
        
    }

 
    
    fileprivate func configureSlideMenu() {
        guard let menu = self.revealViewController() else {return}
        
        let gesture = menu.panGestureRecognizer()
        self.view.addGestureRecognizer(gesture!)
        
        guard let nav = menu.rearViewController as? UINavigationController else {return}
        guard let rear = nav.topViewController as? SideMenuFilterViewController else {return}
//        rear.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as? StoresTableViewCell
        let store = stores[indexPath.row]
        var addressString = ""
        addressString = (store.address["address_line_1"] as? String)! + "\n" + (store.address["city"] as? String)! + ", " + (store.address["state"] as? String)!
        
        cell?.storeName.text = store.storeName
        cell?.storeAddress?.text = addressString
        cell?.updateUIToCardView()
        
        return cell!
    }
    
}

//MARK: Actions
extension StoresTableViewController {
    
    @IBAction func onFilterTapped(_ sender: Any) {
        
        if let revealController = self.revealViewController() {
            revealController.revealToggle(animated: true)
        }
    }
    
}
