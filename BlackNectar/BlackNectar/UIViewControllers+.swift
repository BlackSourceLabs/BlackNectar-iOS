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
import NVActivityIndicatorView
import UIKit

extension UIViewController {
    
    func startSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func stopSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    func startSpinningNVActivityIndicator() {
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    func stopSpinningNVActivityIndicator() {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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


