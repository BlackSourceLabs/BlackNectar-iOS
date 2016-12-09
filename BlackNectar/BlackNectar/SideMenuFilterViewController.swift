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

}


class SideMenuFilterViewController: UITableViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var storesButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentViewCell: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAttributes()
    }



    public var distanceFilter: Double?
    var delegate: SideMenuFilterViewControllerDelegate?
    var hoursOfOperation: Bool?
    var isRestaurant: Bool?
    var isStore: Bool?
    var openNowSwitchValue: Bool?



    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let sliderValue = slider.value
        print("slider value is : \(sliderValue)")

    }

    @IBAction func openNowSwitchOffOn(_ sender: Any) {

        if openNowSwitch.isOn {

            openNowSwitchValue = true

        } else {

            openNowSwitchValue = false
        }

        print("openNowSwitch was set to : \(openNowSwitchValue)")

    }

    @IBAction func restaurantPressed(_ sender: Any) {

        if isRestaurant == nil {
            isRestaurant = true
            restaurantButton.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor
        }else if isRestaurant == true {
            isRestaurant = false
            restaurantButton.layer.backgroundColor = UIColor.darkGray.cgColor
        }else {
            isRestaurant = true
            restaurantButton.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor

        }

    }

    @IBAction func storesPressed(_ sender: Any) {

        if isStore == nil {
            isStore = true
            storesButton.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor
        }else if isStore == true {
            isStore = false
            storesButton.layer.backgroundColor = UIColor.darkGray.cgColor
        }else {
            isStore = true
            storesButton.layer.backgroundColor = UIColor.init(red: 0.902, green: 0.73, blue: 0.25, alpha: 1).cgColor
        }
        print("isStore variable set to : \(isStore)")

    }

    @IBAction func applyPress(_ sender: Any) {

    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "applyButtonSegue" {
//            let destinationVC = segue.destination as! StoresTableViewController
//            destinationVC.filterDelegate = self
//            destinationVC.filterDelegate.getDistanceValue()
//            print("tableview filterdelegate: getDistance value is : \(destinationVC.filterDelegate.getDistanceValue())")
//            destinationVC.filterDelegate.getOpenNow()
//            destinationVC.filterDelegate.getRestaurantsOrStores()
//        }
//    }

    func onButtonTap(sender: UIButton) {

        delegate?.onButtonTap(sender: sender)

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

    func getDistanceValue() -> Double {
        return distanceFilter!
    }
    func getOpenNow() -> Bool {
        return hoursOfOperation!
    }
    func getRestaurantsOrStores() -> (Bool, Bool) {
        return (isStore!, isRestaurant!)
    }


}
