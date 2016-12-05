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
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var openNowLabel: UILabel!
    
    @IBOutlet weak var openNowSwitch: UISwitch!
    
    @IBAction func openNowSwitchOffOn(_ sender: Any) {
        if openNowSwitch.isOn {
            openNowSwitchValue = true
        } else {
            openNowSwitchValue = false
        }
        print("openNowSwitch was set to : \(openNowSwitchValue)")
    }
    
    var openNowSwitchValue: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.minimumValue = 0
        slider.maximumValue = 25
    }
    var delegate: SideMenuFilterViewControllerDelegate?
    public var distanceFilter: Double?
    var hoursOfOperation: Bool?
    var isResturant: Bool?
    var isStore: Bool?
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
    let sliderValue = slider.value
    print("slider value is : \(sliderValue)")
    }
    
    
    func onButtonTap(sender: UIButton) {
        delegate?.onButtonTap(sender: sender)
    }
}
