//
//  SideMenuFilterViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/1/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit
import SWRevealController

protocol SideMenuFilterViewControllerDelegate {
    
    func onButtonTap(sender: UIButton)
    
    /*
   var radius = distanceFilter
   SearchStores.searchstoreslocations(userLocation) {
     https: apicall.call/\(radius)
     }
 */
    
}

class SideMenuFilterViewController: UITableViewController, SWRevealViewControllerDelegate {
    
    var delegate: SideMenuFilterViewControllerDelegate?
    public var distanceFilter: Double?
    var hoursOfOperation: Bool?
    var isResturant: Bool?
    var isStore: Bool?
    
    func onButtonTap(sender: UIButton) {
        delegate?.onButtonTap(sender: sender)
    }
}
