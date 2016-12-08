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

//TODO: Integrate with Carthage

class StoresTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var filterButton: UIButton!
    
    var stores: [StoresInfo] = []
    var currentLocation = UserLocation().prepareForLocation()
    var filterDelegate = SideMenuFilterViewController()
    
    let async: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        return operationQueue
    }()
    private let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation().prepareForLocation()
        
        SearchStores.searchForStoresLocations(near: currentLocation) { stores in
            
            self.stores = stores
            print("TableViewController, stores is : \(self.stores)")
            
            self.main.addOperation {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func configureSlideMenu() {
        
        guard let menu = self.revealViewController() else { return }
        
        let gesture = menu.panGestureRecognizer()
        self.view.addGestureRecognizer(gesture!)
        
        guard let nav = menu.rearViewController as? UINavigationController else { return }
        guard let rear = nav.topViewController as? SideMenuFilterViewController else { return }
        
    }
    
    func goLoadImage(into cell: StoresTableViewCell, withStore url: URL) {
        
        async.addOperation {
            
            do {
                let data = try Data(contentsOf: url)
                let image = try UIImage(data: data)
               
                
                self.main.addOperation {
                    cell.storeImage.image = image
                }
         
            } catch {
                print("error")
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
        
        //WTF IS THIS? FUNCTION PLEASE
        //Call it, combine addresses
        //PLEASE 🙏🏽
        addressString = (store.address["address_line_1"] as? String)! + "\n" + (store.address["city"] as? String)! + ", " + (store.address["state"] as? String)!
        
        //Don't load images in the main thread.
        //Always do this shit async, so it doesn't slow down the table view
        //TODO: Load the image in another function
        
        
        
        
        goLoadImage(into: cell, withStore: store.storeImage)
        cell.storeName.text = store.storeName
        cell.storeAddress.text = addressString
        //        cell.updateUIToCardView()
        
        return cell
    }
    
    
    
    //    func loadStores() {
    //
    //        async.addOperation {
    //
    //            //THINK! How are you supposed to get the stores?
    //            let getTheStores = StoresTableViewCell()
    //            print("Operation completed")
    //        }
    //
    //    }
    
}

//MARK: Actions
extension StoresTableViewController {
    
    @IBAction func onFilterTapped(_ sender: Any) {
        
        if let revealController = self.revealViewController() {
            revealController.revealToggle(animated: true)
        }
        
    }
    
    
}
