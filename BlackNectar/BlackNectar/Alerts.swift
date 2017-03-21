//
//  Alerts.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 3/20/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(_ alert: UIAlertController) {
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        
        presentAlert(alert)
    }
    
    func showAlertWithError(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func createAlertToSendUserToLocationSettings() -> UIAlertController {
        
        let title = "Requesting GPS Access"
        let message = "Please go to \"Location\" and enable \"While Using the App\""
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let openSettings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.sendUserToSettings()
            self.makeNoteThatSendingUserToSettings()
        }
        
        controller.addAction(openSettings)
        
        return controller
    }
    
    func sendUserToSettings() {
        
        let link = UIApplicationOpenSettingsURLString
        
        guard let url = URL(string: link) else {
            LOG.error("Failed to create URL to \(link)")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
}

//MARK: StoresTableViewController Alert View Code
extension StoresTableViewController {
    
    func sendEmailErrorAlert() {
        
        let alert = createAlertForEmailError()
        self.presentAlert(alert)
        
    }
    
    func createAlertForEmailError() -> UIAlertController {
        
        let title = "Sending Email Failed"
        let message = "Your device did not successfully send the Email. Please check your wi-fi settings or signal strength and try again."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            self.present(self.configureMailComposeViewController(), animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(ok)
        controller.addAction(cancel)
        
        return controller
        
    }
    
}

//MARK: FilterViewController Alert View Code
extension FilterViewController {
    
    func createAlertToSelectAnOption() -> UIAlertController {
        
        let title = "Select An Option"
        let message = "You must select at least one option. We need a location to find EBT stores around you."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let myLocationOption = UIAlertAction(title: "Use My Location", style: .default) { _ in
            let alert = self.createAlertToRequestGPSPermissions()
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let zipCodeOption = UIAlertAction(title: "Use Zip Code", style: .default) { _ in
            let alert = self.createAlertToGetZipCode()
            self.present(alert, animated: true, completion: nil)
            
        }
        
        controller.addAction(myLocationOption)
        controller.addAction(zipCodeOption)
        
        return controller
    }
    
    func createAlertToRequestGPSPermissions() -> UIAlertController {
        
        let title = "Requesting GPS Access"
        let message = "By granting us access, we can find EBT stores around you."
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            if self.zipCode.notEmpty {
                self.useZipCode = true
                return
            }
            else {
                
                let alert = self.createAlertToSelectAnOption()
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            self.requestGPSAccess()
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        
        return controller
    }
    
    func createAlertToGetZipCode() -> UIAlertController {
        
        let title = "Enter Zip Code"
        let message = "Please enter a valid zip code.(eg - 90401)"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            if !self.useZipCode {
                let alert = self.createAlertToSelectAnOption()
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        let go = UIAlertAction(title: "Go", style: .default) { _ in
            
            guard let zipCode = controller.textFields?.first?.text, zipCode.notEmpty else {
                
                self.makeNoteThatNoZipCodeEntered()
                let warning = self.createAlertToWarnOfInvalidZip(zip: "")
                self.present(warning, animated: true, completion: nil)
                
                return
            }
            
            self.moveMapTo(zipCode: zipCode)
            self.loadStoresInZipCode(at: zipCode)
            self.zipCode = zipCode
            self.useZipCode = true
            self.useMyLocation = false
            self.styleZipCodeButton()
        }
        
        controller.addAction(cancel)
        controller.addAction(go)
        
        controller.addTextField() { zipCode in
            zipCode.placeholder = "(eg - 10455)"
            zipCode.keyboardType = .numberPad
        }
        
        return controller
    }
    
    func createAlertToWarnOfInvalidZip(zip: String) -> UIAlertController {
        
        let title = "Invalid Zip Code."
        let message = "Please enter a valid zip code"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.useZipCode = false
            
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let newAlert = self.createAlertToGetZipCode()
            
            self.present(newAlert, animated: true, completion: nil)
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        
        return controller
    }
    
}

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        
        actions.forEach(self.addAction)
    }
}

//MARK: Aroma Messages
fileprivate extension UIViewController {
    
    func makeNoteThatSendingUserToSettings() {
        
        let message = "Sending User to 'Settings' so they can enable Location Services"
        AromaClient.sendMediumPriorityMessage(withTitle: "Sending User To Settings", withBody: message)
    }
    
}
