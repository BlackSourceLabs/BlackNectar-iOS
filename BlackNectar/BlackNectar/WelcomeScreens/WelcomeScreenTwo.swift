//
//  WelcomeScreenTwo.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 3/3/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import AromaSwiftClient
import Foundation
import UIKit


class WelcomeScreenTwo : UIViewController {
    
    
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Welcome Screen 2 Loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Welcome Screen 2", withBody: "Proceeding to Welcome Screen 3 after user tapped background")
        goToNext()
        
    }
}

//MARK: Segues 
extension WelcomeScreenTwo {
    
    func goToNext() {
        
        self.performSegue(withIdentifier: "next", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let next = segue.destination as? WelcomeScreenThree {
            next.delegate = self.delegate
        }
    }
}
