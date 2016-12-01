//
//  StoresTableViewCell.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 11/30/16.
//  Copyright © 2016 Black Whole. All rights reserved.
//

import Foundation
import UIKit


class StoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var storeDistance: UILabel!
    
    
     func updateUIToCardView() {
        
        backgroundCardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }
    
    
    
}

    
    
    

