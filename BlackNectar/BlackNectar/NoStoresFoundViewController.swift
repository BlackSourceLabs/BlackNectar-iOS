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
