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

protocol SideMenuFilterDelegate {
    
    func onApply(_ filter: SideMenuFilterViewController, restaurants: Bool, stores: Bool, openNow: Bool, distanceInMiles: Int)
    func onCancel()
    
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
    
    var distanceFilter = 0
    var isRestaurant = false
    var isStore = false
    var isOpenNow = false
    
    var delegate: SideMenuFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleMenu()
        
    }
    
    func checkFrontAndRearViewController(callback: @escaping ((SideMenuFilterDelegate) -> Void)) {
        
        
        let sideMenuRevealInstance =  self.revealViewController().frontViewController as? UIViewController
        sideMenuRevealInstance
        
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        distanceFilter = Int(slider.value)
        
        if distanceFilter != 0 {
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
        
        if isRestaurant == false {
            
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
        
        if isStore == false {
            
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
        
        checkFrontAndRearViewController(callback: { delegate in
            
            self.delegate?.onApply(self, restaurants: self.isRestaurant, stores: self.isStore, openNow: self.isOpenNow, distanceInMiles: self.distanceFilter)

            }
        )
        
//        guard let delegate = self.delegate else {
//           
//            return
//        }
//        
    
    }
    
    private func styleMenu() {
        
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
