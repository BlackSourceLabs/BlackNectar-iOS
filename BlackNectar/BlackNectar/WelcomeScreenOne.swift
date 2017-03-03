//
//  WelcomeScreenOne.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/23/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

class WelcomeScreenOne: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        goToNextScreen()
        
    }
}


//MARK: Segues
fileprivate extension WelcomeScreenOne {
    
    func goToNextScreen() {
        
        self.performSegue(withIdentifier: "next", sender: self)
        
    }
}
