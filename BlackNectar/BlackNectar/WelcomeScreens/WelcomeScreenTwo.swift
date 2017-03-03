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
    
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        goToNext()
        
    }
}

//MARK: Segues 
fileprivate extension WelcomeScreenTwo {
    
    func goToNext() {
        
        self.performSegue(withIdentifier: "next", sender: self)
    }
}
