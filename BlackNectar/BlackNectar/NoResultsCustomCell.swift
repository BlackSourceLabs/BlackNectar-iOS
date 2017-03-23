//
//  NoResultsCustomCell.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 3/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

class NoResultsCustomCell: UITableViewCell {
    
    @IBOutlet weak var noStoresFoundImage: UIImageView!
    @IBOutlet weak var noStoresFoundLabel: UILabel!
    @IBOutlet weak var knowOfAnyLabel: UILabel!
    @IBOutlet weak var letUsKnowButton: UIButton!
    
    var onEmailButtonPressed: ((NoResultsCustomCell) -> ())?
    
    @IBAction func didTapEmailButton(_ sender: UIButton) {
        
        onEmailButtonPressed?(self)
        
    }
    
}
