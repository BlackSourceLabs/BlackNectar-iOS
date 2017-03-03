//
//  WelcomeScreenFour.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 3/3/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation
import UIKit

class WelcomeScreenFour: UIViewController {
    
    @IBOutlet weak var myLocationButton: CustomButtonView!
    @IBOutlet weak var zipCodeButton: CustomButtonView!
    @IBOutlet weak var nextButton: CustomButtonView!
    
    @IBOutlet weak var locationPin: UIImageView!
    @IBOutlet weak var locationPinCenterXMyLocation: NSLayoutConstraint!
    @IBOutlet weak var locationPinCenterYMyLocation: NSLayoutConstraint!
    @IBOutlet weak var locationPinCenterYZipCode: NSLayoutConstraint!
    @IBOutlet weak var locationPinCenterXZipCode: NSLayoutConstraint!
    
    
    fileprivate var eitherOneSelected: Bool {
        
        return UserPreferences.instance.useMyLocation ||
               UserPreferences.instance.useZipCode
    }
    
    fileprivate var neitherSelected: Bool {
        
        return !eitherOneSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateButtons(animated: false)
    }
   
    
    fileprivate func dismiss() {
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: IB Actions
extension WelcomeScreenFour {
    
    @IBAction func didSelectMyLocation(_ sender: Any) {
        
        let alert = createAlertToRequestGPS()
        presentAlert(alert)
    }
    
    @IBAction func didSelectZipCode(_ sender: Any) {
        
        let alert = createAlertToRequestZipCode()
        presentAlert(alert)
    }
    
    @IBAction func didSelectNext(_ sender: Any) {
        
        self.dismiss()
    }
    
}

//MARK: Alert Views 
fileprivate extension WelcomeScreenFour {
    
    func createAlertToRequestGPS() -> UIAlertController {
        
        let title = "Enable GPS?"
        let message = "GPS is used to find EBT stores around you, and only while you are in the app"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            
            self.requestGPS()
        }
        
        alert.addActions(cancel, ok)
        
        return alert
    }
    
    func createAlertToRequestZipCode() -> UIAlertController {
        
        let title = "Enter Zip Code"
        let message = "Enter the 5-digit Zip Code to search"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = createZipButtonOkButton(for: alert)
        
        alert.addActions(cancel, ok)
        
        alert.addTextField() { textField in
            
            textField.keyboardType = .numberPad
            textField.becomeFirstResponder()
        }
        
        return alert
    }
    
    
    func createZipButtonOkButton(for alert: UIAlertController) -> UIAlertAction {
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let zipCode = alert.textFields?.first?.text, zipCode.notEmpty else {
                
                self.showAlertWithError(message: "Zip Code cannot be empty")
                return
            }
            
            let valid = self.isValidZipCode(zipCode)
            
            guard valid.isValid else {
                
                let message = valid.errorMessage
                
                LOG.warn("Invalid Zip Code: \(message)")
                self.showAlertWithError(message: message)
                
                return
            }
            
            self.useZipCode = true
            self.zipCode = zipCode
            self.updateButtons()
        }
        
        return ok
    }
}

//MARK: Location Code 
fileprivate extension WelcomeScreenFour {
    
    
    var useGPS: Bool {
        
        get {
            return UserPreferences.instance.useMyLocation
        }
        
        set (newValue) {
            UserPreferences.instance.useMyLocation = newValue
            UserPreferences.instance.useZipCode = !newValue
        }
    }
    
    var useZipCode: Bool {
        
        get {
            return UserPreferences.instance.useZipCode
        }
        
        set (newValue) {
            UserPreferences.instance.useZipCode = newValue
            UserPreferences.instance.useMyLocation = !newValue
        }
    }
    
    var zipCode: String {
        
        get {
            return UserPreferences.instance.zipCode ?? ""
        }
        
        set (newValue) {
            UserPreferences.instance.zipCode = newValue
        }
    }
    
    func requestGPS() {
        
        if let status = UserLocation.instance.currentStatus, status == .denied {
            
            let alert = self.createAlertToSendUserToLocationSettings()
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        UserLocation.instance.requestLocation() { location in
            
            LOG.info("GPS successfully enabled")
            self.useGPS = true
            self.updateButtons()
        }
    }
    
    func isValidZipCode(_ zipCode: String) -> (isValid: Bool, errorMessage: String) {
        
        if zipCode.isEmpty {
            
            return (false, "Zip Code is Empty")
        }
        
        if zipCode.characters.count != 5 {
            
            return (false, "Zip Code must be 5 digits")
        }
        
        guard let _ = Int(zipCode) else {
            return (false, "Zip Code must be numerical")
        }
        
        return (true, "")
    }
}


//MARK: UI Setup
fileprivate extension WelcomeScreenFour {
    
    func updateButtons(animated: Bool = true) {

        
        if useGPS {
            
            showPin(animated: animated)
            selectGPSButton(animated: animated)
        }
        else if useZipCode {
            
            showPin(animated: animated)
            selectZipCodeButton(animated: animated)
        }
        else {
            
            hidePin(animated: animated)
            disableNextButton()
        }
    }
    
    func selectZipCodeButton(animated: Bool = true) {
        
        uncloakZipCode()
        disableZipCodeButton()
        movePinToZipCode(animated: animated)
        
        enableMyLocationButton()
        cloakMyLocationButton()
    }
    
    func selectGPSButton(animated: Bool = true) {
        
        uncloakMyLocationButton()
        disableMyLocationButton()
        movePinToMyLocation(animated: animated)
        
        enableZipCodeButton()
        cloakZipCode()
    }

    func enableZipCodeButton() {
        
        zipCodeButton.isEnabled = true
    }
    
    func disableZipCodeButton() {
        
        zipCodeButton.isEnabled = false
    }
    
    func cloakZipCode() {
        
        zipCodeButton.alpha = 0.6
    }
    
    func uncloakZipCode() {
        
        zipCodeButton.alpha = 1.0
    }
    
    func enableMyLocationButton() {
        
        self.myLocationButton.isEnabled = true
    }
    
    func disableMyLocationButton() {
        
        self.myLocationButton.isEnabled = false
    }
    
    func cloakMyLocationButton() {
        
        self.myLocationButton.alpha = 0.6
    }
    
    func uncloakMyLocationButton() {
        
        self.myLocationButton.alpha = 1.0
    }
    
    func enableNextButton() {
        
        let animations = {
            
            self.nextButton.isEnabled = true
            self.nextButton.alpha = 1.0
        }
        
        animate(withView: self.nextButton, animations: animations)
    }
    
    func disableNextButton() {
        
        let animations = {
            
            self.nextButton.isEnabled = false
            self.nextButton.alpha = 0.6
        }
        
        animate(withView: self.nextButton, animations: animations)
    }
    
    
    func movePinToZipCode(animated: Bool = true) {
        
        let animations = {
            
            self.locationPinCenterXMyLocation.isActive = false
            self.locationPinCenterYMyLocation.isActive = false
            
            self.locationPinCenterXZipCode.isActive = true
            self.locationPinCenterYZipCode.isActive = true
            
//            if animated {
            
                self.view.layoutIfNeeded()
//            }
        }
        
        if animated {
            
            animate(withView: self.locationPin, animations: animations)
        }
        else {
            
            animations()
        }
    }
    
    func movePinToMyLocation(animated: Bool = true) {
        
        let animations = {
            
            self.locationPinCenterXZipCode.isActive = false
            self.locationPinCenterYZipCode.isActive = false
            
            self.locationPinCenterXMyLocation.isActive = true
            self.locationPinCenterYMyLocation.isActive = true
            
//            if animated {
            
                self.view.layoutIfNeeded()
//            }
        }
        
        if animated {
            
            animate(withView: self.locationPin, animations: animations)
        }
        else {
            
            animations()
        }
        
    }
    
    func hidePin(animated: Bool = false) {
        
        let animations = {
            
            self.locationPin.isHidden = true
        }
        
        if animated {
            
            animate(withView: self.locationPin, animations: animations)
        }
        else {
            
            animations()
        }
    }
    
    func showPin(animated: Bool = false) {
        
        let animations = {
            
            self.locationPin.isHidden = false
        }
        
        if animated {
            
            animate(withView: self.locationPin, animations: animations)
        }
        else {
            
            animations()
        }
    }
    
    func animate(withView view: UIView, animations: @escaping () -> ()) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: animations, completion: nil)
//        UIView.transition(with: self.view, duration: 0.4, options: .curveEaseInOut, animations: animations, completion: nil)
    }
    
}
