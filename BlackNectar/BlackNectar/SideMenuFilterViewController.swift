//
//  SideMenuFilterViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/1/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation
import SWRevealController
import UIKit

protocol SideMenuFilterDelegate {

    func didApplyFilters(_ filter: SideMenuFilterViewController, restaurants: Bool, stores: Bool, openNow: Bool, distanceInMiles: Int)
    func didCancelFilters()

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

    var distanceFilter = 0.00
    var isRestaurant = false
    var isStore = false
    var isOpenNow = false
    var delegate: SideMenuFilterDelegate?
    let defaultPreferences = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleMenu()
        loadDefaults()

    }

    func passingDistance() -> Double {
        
        return distanceFilter
    
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        distanceFilter = Double(slider.value)
        
        let roundedNumber = (round(distanceFilter * 100)/100)
        
        if roundedNumber != 0 {
            
            slideValueLabel.text = "\(roundedNumber)"
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
            styleButtonOn(button: restaurantButton)

        } else if isRestaurant == true {

            isRestaurant = false
            styleButtonOff(button: restaurantButton)

        } else {

            isRestaurant = true
            styleButtonOn(button: restaurantButton)

        }

    }

    @IBAction func onStore(_ sender: Any) {

        if isStore == false {

            isStore = true
            styleButtonOn(button: storesButton)

        } else if isStore == true {

            isStore = false
            styleButtonOff(button: storesButton)

        } else {

            isStore = true
            styleButtonOn(button: storesButton)

        }

    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        
        setUserPreferences()
        
        self.delegate?.didApplyFilters(self, restaurants: self.isRestaurant, stores: self.isStore, openNow: self.isOpenNow, distanceInMiles: Int(self.distanceFilter))
        AromaClient.beginMessage(withTitle: "Apply Button Selected")
            .addBody("Users Filter Settings: restaurants button is \(self.isRestaurant), stores button is \(self.isStore), isopenNow switch is \(self.isOpenNow)")
            .withPriority(.medium)
            .send()
        

        closeSideMenu()

    }

    @IBAction func cancelButton(_ sender: UIButton) {

        closeSideMenu()

    }


    private func styleMenu() {

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

    func styleButtonOn(button: UIButton) {

        button.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor

    }

    func styleButtonOff(button: UIButton) {

        button.layer.backgroundColor = UIColor.darkGray.cgColor

    }

}

extension SideMenuFilterViewController {

    func closeSideMenu() {

        if let revealController = self.revealViewController() {
            revealController.revealToggle(animated: true)

        }

    }

    
    func setUserPreferences() {
        
        defaultPreferences.set(distanceFilter, forKey: "distanceFilter")
        defaultPreferences.set(isRestaurant, forKey: "isRestaurant")
        defaultPreferences.set(isOpenNow, forKey: "isOpenNow")
        defaultPreferences.set(isStore, forKey: "isStore")
        
    }
    
    func loadDefaults() {
        
        if defaultPreferences.double(forKey: "distanceFilter") > 0 {
            
            distanceFilter = defaultPreferences.double(forKey: "distanceFilter")
            isRestaurant = defaultPreferences.bool(forKey: "isRestaurant")
            isOpenNow = defaultPreferences.bool(forKey: "isOpenNow")
            isStore = defaultPreferences.bool(forKey: "isStore")
            
            let roundedNumber = (round(defaultPreferences.double(forKey: "distanceFilter") * 100)/100)
            
            slider.value = Float(defaultPreferences.double(forKey: "distanceFilter"))
            slideValueLabel.text = "\(roundedNumber)"
            
            switch isRestaurant || isOpenNow || isStore {
            
            case isRestaurant == true:
                styleButtonOn(button: restaurantButton)
            
            case isStore == true:
                styleButtonOn(button: storesButton)
            
            case isOpenNow == true:
                openNowSwitch.setOn(true, animated: true)
                
            default:
                return
                
            }
            
        }
        
    }
    
}
