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

class StoresTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var stores: [StoresInfo] = []
    var currentLocation = UserLocation().prepareForLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation().prepareForLocation()
        SearchStores.searchForStoresLocations(near: currentLocation) { stores in
            self.stores = stores
            print("TableViewController, stores is : \(self.stores)")
            self.tableView.reloadData()
        }

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
