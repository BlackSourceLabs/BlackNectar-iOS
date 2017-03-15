//
//  NoStoresFoundViewController.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 3/13/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation
import UIKit
import MessageUI

protocol NoStoresFoundDelegate {
    
    func noStoresFound()
    
}

class NoStoresFoundViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let mailComposeViewController = MFMailComposeViewController()
    var delegate: NoStoresFoundDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUsersEmailSettings()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: Present Filter View Controller
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        presentFilterViewController()
        
    }
    
    fileprivate func presentFilterViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController")
        
        present(filterViewController, animated: true, completion: nil)
        
    }
    
    //MARK: Setup MFMailCompose and Send Email
    @IBAction func letUsKnowButtonTapped(_ sender: UIButton) {
        
        sendEmail()
        
    }
    
    fileprivate func sendEmail() {
        
        if !MFMailComposeViewController.canSendMail() {
            
            sendUserToSettingsAlert()
            makeNoteThatUserHasMailSettingsDisabled()
            
        } else {
            
            self.present(configureMailComposeViewController(), animated: true, completion: nil)
            
        } 
        
    }
    
    fileprivate func checkUsersEmailSettings() {
        
        if !MFMailComposeViewController.canSendMail() {
            
            sendUserToSettingsAlert()
            makeNoteThatUserHasMailSettingsDisabled()
            
        } else {
            
            return
        }
        
    }
    
    fileprivate func configureMailComposeViewController() -> MFMailComposeViewController {
        
        mailComposeViewController.mailComposeDelegate = self
        
        mailComposeViewController.setToRecipients(["feedback@blacksource.tech"])
        mailComposeViewController.setSubject("We love feeback - Place your comment below")
        mailComposeViewController.setMessageBody("We are open to all feedback. Let us know if there are no stores in your area that accept EBT.", isHTML: false)
        
        return mailComposeViewController
        
    }
    
    //MARK: MFMailCompose Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error {
            
            makeNoteThatSendingEmailFailed(withError: "\(error)")
            sendEmailErrorAlert()
            return
            
        }
        
        makeNoteThatUserFinishedEmail(withResult: "\(result)")
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK: Alert View Code
fileprivate extension NoStoresFoundViewController {
    
    fileprivate func sendEmailErrorAlert() {
        
        let alert = createAlertForEmailError()
        self.presentAlert(alert)
        
    }
    
    fileprivate func sendUserToSettingsAlert() {
        
        let alert = createAlertToSendUserToSettings()
        self.presentAlert(alert)
        
    }
    
    fileprivate func createAlertForEmailError() -> UIAlertController {
        
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
    
    fileprivate func createAlertToSendUserToSettings() -> UIAlertController {
        
        let title = "Requesting Mail Access"
        let message = "Please go to \"Settings\" -> \"Mail\" -> \"Accounts\" -> \"Select your Account or add Account\" -> \"Enable Mail\""
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let openSettings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.sendUserToSettings()
            self.makeNoteThatSendingUserToSettingsForMail()
        }
        
        controller.addAction(openSettings)
        
        return controller
        
    }
    
}

//MARK: Aroma Messages
fileprivate extension NoStoresFoundViewController {
    
    func makeNoteThatUserFinishedEmail(withResult result: String) {
        
        LOG.info("Email Result is: \(result)")
        AromaClient.beginMessage(withTitle: "User Finished Email with: \(result)")
            .addBody("Finished Email: (\(result))")
            .withPriority(.low)
            .send()
        
    }
    
    func makeNoteThatSendingEmailFailed(withError error: String) {
        
        LOG.error("There was an error with the email: \(error)")
        AromaClient.beginMessage(withTitle: "There was an error with the email: \(error)")
            .addBody("Email Error is: \(error)")
            .withPriority(.medium)
            .send()
        
    }
    
    func makeNoteThatSendingUserToSettingsForMail() {
        
        let message = "Sending User to 'Settings' so they can enable Mail Services"
        AromaClient.sendMediumPriorityMessage(withTitle: "Sending User To Settings", withBody: message)
        
    }
    
    func makeNoteThatUserHasMailSettingsDisabled() {
        
        LOG.error("User has mail settings disabled")
        AromaClient.beginMessage(withTitle: "User has mail settings disabled")
            .addBody("User has mail settings disabled or doesn't have an account")
            .withPriority(.medium)
            .send()
        
    }
    
}
