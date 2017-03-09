//
//  UIViewControllers+.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation
import UIKit

extension UIViewController {
    
    func startSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func stopSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    func hideNavigationBar() {
        guard let nav = self.navigationController?.navigationBar else { return }
        
        nav.isTranslucent = true
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.shadowImage = UIImage()
        nav.backgroundColor = UIColor.clear
    }
    
    func showNavigationBar() {
        guard let nav = self.navigationController?.navigationBar else { return }
        nav.isTranslucent = false
    }
}

//MARK: Alert Controllers 

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
            self.senduserToSettings()
            self.makeNoteThatSendingUserToSettings()
        }
        
        controller.addAction(openSettings)
        
        return controller
    }
    
    private func senduserToSettings() {
        
        let link = UIApplicationOpenSettingsURLString
        
        guard let url = URL(string: link) else {
            LOG.error("Failed to create URL to \(link)")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
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
