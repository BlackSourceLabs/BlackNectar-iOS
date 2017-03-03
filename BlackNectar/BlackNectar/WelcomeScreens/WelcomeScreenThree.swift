//
//  WelcomeScreenThree.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 3/3/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

class WelcomeScreenThree: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var farmersMarketButton: CustomButtonView!
    @IBOutlet weak var farmersMarketLabel: UILabel!
    
    @IBOutlet weak var groceryStoresButton: CustomButtonView!
    @IBOutlet weak var groceryStoresLabel: UILabel!
    
    @IBOutlet weak var farmersMarketOpacity: UIView!
    @IBOutlet weak var groceryStoresOpacity: UIView!
    
    @IBOutlet weak var farmersMarketPin: UIImageView!
    @IBOutlet weak var groceryStoresPin: UIImageView!
    
    @IBOutlet weak var nextButton: CustomButtonView!
    
    fileprivate var eitherOneSelected: Bool {
        return UserPreferences.instance.showFarmersMarkets ||
               UserPreferences.instance.showStores
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButtons()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if eitherOneSelected {
            self.goToNext()
        }
    }
}

//MARK: Button Actions 
extension WelcomeScreenThree {
    
    @IBAction func didSelectFarmersMarket(_ sender: Any) {
        
        UserPreferences.instance.showFarmersMarkets = !UserPreferences.instance.showFarmersMarkets
        updateButtons()
        
    }
    
    @IBAction func didSelectGroceryStores(_ sender: Any) {
        
        UserPreferences.instance.showStores = !UserPreferences.instance.showStores
        updateButtons()
    }
    
}

//MARK: Segues 
fileprivate extension WelcomeScreenThree {
    
    func goToNext() {
        self.performSegue(withIdentifier: "next", sender: self)
    }
}

//MARK: UI Setup 
fileprivate extension WelcomeScreenThree {
    
    private var neitherSelected: Bool {
        return !UserPreferences.instance.showFarmersMarkets &&
            !UserPreferences.instance.showStores
    }
    
    func updateButtons() {
        
        if UserPreferences.instance.showFarmersMarkets {
            selectFarmersMarket()
        }
        else {
            deselectFarmersMarket()
        }
        
        if UserPreferences.instance.showStores {
            selectGroceryStores()
        }
        else {
            deselectGroceryStores()
        }
        
        if neitherSelected {
            disableNextButton()
        }
        else {
            enableNextButton()
        }
    }
    
    func selectFarmersMarket() {
        
        let animations = {
            self.farmersMarketOpacity.isHidden = false
            self.farmersMarketPin.isHidden = false
        }
        
        animate(withView: self.farmersMarketButton, animations: animations)
    }
    
    func deselectFarmersMarket() {
        
        let animations = {
            self.farmersMarketOpacity.isHidden = true
            self.farmersMarketPin.isHidden = true
        }
        
        animate(withView: self.farmersMarketButton, animations: animations)
    }
    
    
    func selectGroceryStores() {
        
        let animations = {
            self.groceryStoresOpacity.isHidden = false
            self.groceryStoresPin.isHidden = false
        }
        
        animate(withView: self.groceryStoresButton, animations: animations)
    }
    
    func deselectGroceryStores() {
        
        let animations = {
            self.groceryStoresOpacity.isHidden = true
            self.groceryStoresPin.isHidden = true
        }
        
        animate(withView: self.groceryStoresButton, animations: animations)
    }
    
    func disableNextButton() {
        
        self.nextButton.isEnabled = false
        self.nextButton.alpha = 0.6
    }
    
    func enableNextButton() {
        
        self.nextButton.isEnabled = true
        self.nextButton.alpha = 1.0
    }
    
    func animate(withView view: UIView, animations: @escaping () -> ()) {
        
        UIView.transition(with: self.farmersMarketButton, duration: 0.3, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
}
