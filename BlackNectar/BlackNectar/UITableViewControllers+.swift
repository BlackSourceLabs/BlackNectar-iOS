//
//  UITableViewControllers+.swift
//  BlackNectar
//
//  Created by Wellington Moreno on 2/16/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewController {
    
    func reloadSection(_ section: Int, animation: UITableViewRowAnimation = .automatic) {
        
        let sections = IndexSet.init(integer: section)
        self.tableView.reloadSections(sections, with: animation)
        
    }
    
}
