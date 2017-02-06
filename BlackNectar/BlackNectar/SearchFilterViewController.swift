//
//  MapViewSearchFilter.swift
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

class SearchFilterViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentCoordinates: CLLocationCoordinate2D?
    
    var stores: [Store] = []
    
    var selectedPin: MKPlacemark?
    var distance = 0.0
    
    var showFarmersMarkets = true
    var showGroceryStores = true
    
    typealias callBack = ([Store]) -> ()
    
    fileprivate let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        return operationQueue
        
    }()
    
    fileprivate let main = OperationQueue.main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadUserDefaults()
        
    }
    
    
    private func loadUserDefaults() {
        
        self.showFarmersMarkets = UserPreferences.instance.isFarmersMarket
        self.showGroceryStores = UserPreferences.instance.isStore
        
    }
    
    
    
    
}


