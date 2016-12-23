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
    
    func onCancel()
    func onApply(restaurants: Bool, stores: Bool, openNow: Bool, distanceInMiles: Int)
    
}

class SideMenuFilterViewController: UITableViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var storesButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentViewCell: UIView!
    @IBOutlet weak var slideValueLabel: UILabel!
    
    var delegate: SideMenuFilterViewControllerDelegate?
    var distanceFilter = 0
    var isRestaurant: Bool?
    var isStore: Bool?
    var isOpenNow: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonAttributes()
        
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        distanceFilter = Int(slider.value)
        
        if distanceFilter != nil {
            let number = String(describing: distanceFilter)
            slideValueLabel.text = number
        }
        
    }
    
    @IBAction func openNowSwitchOffOn(_ sender: Any) {
        
        if openNowSwitch.isOn {
            
            isOpenNow = true
            
        } else {
            
            isOpenNow = false
        }
        
    }
    
    @IBAction func onRestaurant(_ sender: Any) {
        
        if isRestaurant == nil {
            
            isRestaurant = true
            onButton(button: restaurantButton)
            
        } else if isRestaurant == true {
            
            isRestaurant = false
            offButton(button: restaurantButton)
            
        } else {
            
            isRestaurant = true
            onButton(button: restaurantButton)
            
        }
        
    }
    
    @IBAction func onStore(_ sender: Any) {
        
        if isStore == nil {
            
            isStore = true
            onButton(button: storesButton)
            
        } else if isStore == true {
            
            isStore = false
            offButton(button: storesButton)
            
        } else {
            
            isStore = true
            onButton(button: storesButton)
            
        }
        
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        
//        guard let delegate = self.delegate else {
//            print("delegate not set")
//            return
//        }

        guard let distance = distanceFilter as Int? else {return}
        guard let isOpen = isOpenNow as Bool? else {return}
        guard let restaurant = isRestaurant as Bool? else {return}
        guard let store = isStore as Bool? else {return}
        
        delegate?.onApply(restaurants: restaurant, stores: store, openNow: isOpen, distanceInMiles: distance)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applyButtonSegue" {
            
            guard let destinationVC = segue.destination as? StoresTableViewController else {return}
            
            if distanceFilter != nil || isOpenNow != nil || isRestaurant != nil || isStore != nil {
                
                destinationVC.distanceFilterValue = distanceFilter
                destinationVC.isRestaurantBool = isRestaurant
                destinationVC.isStoreBool = isStore
                destinationVC.openNowSwitchBool = isOpenNow
                destinationVC.filterDelegate = self
            }
        }
    }
    
    func setButtonAttributes() {
        
        slider.minimumValue = 2
        slider.maximumValue = 25
        
        applyButton.layer.borderColor = UIColor.white.cgColor
        applyButton.layer.borderWidth = 2
        applyButton.layer.cornerRadius = 10
        
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.cornerRadius = 10
        
        restaurantButton.layer.cornerRadius = 10
        storesButton.layer.cornerRadius = 10
        
        contentViewCell.layer.opacity = 0.75
        
    }
    
    
}

extension SideMenuFilterViewController {
    
    func onButton(button: UIButton) {
        
        button.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor
        
    }
    
    func offButton(button: UIButton) {
        
        button.layer.backgroundColor = UIColor.darkGray.cgColor
        
    }
}
