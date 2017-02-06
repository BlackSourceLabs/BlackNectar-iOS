//
//  SideMenuFilterViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/1/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation
import SWRevealController
import UIKit

protocol SideMenuFilterDelegate {

    func didOpenFilterMenu()
    func didCloseFilterMenu()
    func didApplyFilters(_ filter: SideMenuFilterViewController, farmersMarkets: Bool, stores: Bool, openNow: Bool, distanceInMiles: Int)
    func didCancelFilters()

}

class SideMenuFilterViewController: UITableViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var farmersMarketButton: UIButton!
    @IBOutlet weak var storesButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentViewCell: UIView!
    @IBOutlet weak var slideValueLabel: UILabel!

    var distanceFilter = 0.00
    var isFarmersMarket = false
    var isStore = false
    var isOpenNow = false
    var delegate: SideMenuFilterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleMenu()
        loadsDefaults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.didOpenFilterMenu()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didCloseFilterMenu()
    }

    func passingDistance() -> Double {
        
        return distanceFilter
    
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        
        UserPreferences.instance.distanceFilter.subtract(distanceFilter)
        
        distanceFilter = Double(slider.value)
        
        let roundedNumber = (round(distanceFilter * 100)/100)
        
        if roundedNumber != 0 {
            
            slideValueLabel.text = "\(roundedNumber)"
        
            UserPreferences.instance.distanceFilter.add(roundedNumber)
        }
        
    }

    @IBAction func openNowSwitchOffOn(_ sender: Any) {

        if openNowSwitch.isOn {

            isOpenNow = true
            UserPreferences.instance.isOpenNow = true
            
        } else {
            
            isOpenNow = false
            UserPreferences.instance.isOpenNow = false
            
        }

    }

    @IBAction func onFarmersMarket(_ sender: UIButton) {

        if isFarmersMarket == false {

            isFarmersMarket = true
            UserPreferences.instance.isFarmersMarket = true
            styleButtonOn(button: farmersMarketButton)
            
        } else {

            isFarmersMarket = false
            UserPreferences.instance.isFarmersMarket = false
            styleButtonOff(button: farmersMarketButton)
            
        }

    }

    @IBAction func onStore(_ sender: Any) {

        if isStore == false {

            isStore = true
            UserPreferences.instance.isStore = true
            styleButtonOn(button: storesButton)
            
        } else {

            isStore = false
            UserPreferences.instance.isStore = false
            styleButtonOff(button: storesButton)

        }

    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        
        self.delegate?.didApplyFilters(self, farmersMarkets: self.isFarmersMarket, stores: self.isStore, openNow: self.isOpenNow, distanceInMiles: Int(self.distanceFilter))
        
        AromaClient.beginMessage(withTitle: "Apply Button Selected")
            .addBody("Users Filter Settings: farmersMarkets button is \(self.isFarmersMarket) | stores button is \(self.isStore) | isOpenNow switch is \(self.isOpenNow)")
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

        farmersMarketButton.layer.cornerRadius = 10
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

}

extension SideMenuFilterViewController {
    
    func loadsDefaults() {
        
        distanceFilter = UserPreferences.instance.distanceFilter
        isFarmersMarket = UserPreferences.instance.isFarmersMarket
        isOpenNow = UserPreferences.instance.isOpenNow
        isStore = UserPreferences.instance.isStore

        UserPreferences.instance.setSideMenuDefaults(in: self, distanceFilter: distanceFilter, isFarmersMarket: isFarmersMarket, isOpenNow: isOpenNow, isStore: isStore)
        
    }
    
}
