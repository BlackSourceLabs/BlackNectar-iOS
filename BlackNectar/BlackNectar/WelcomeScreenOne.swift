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

    
    private var isNavBarHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavBarHidden = self.navigationController?.isNavigationBarHidden ?? true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.isNavigationBarHidden = true
        guard let nav = self.navigationController?.navigationBar else { return }
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.shadowImage = UIImage()
        nav.isTranslucent = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = isNavBarHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
