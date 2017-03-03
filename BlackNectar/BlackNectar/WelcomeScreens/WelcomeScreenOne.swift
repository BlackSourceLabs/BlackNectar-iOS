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

    private var timer: Timer!
    
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.goToNextScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        timer?.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        goToNextScreen()
        
    }
}


//MARK: Segues
extension WelcomeScreenOne {
    
    func goToNextScreen() {
        
        self.performSegue(withIdentifier: "next", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let next = segue.destination as? WelcomeScreenTwo {
            next.delegate = self.delegate
        }
    }
}
