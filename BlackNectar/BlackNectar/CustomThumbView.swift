//
//  customThumbView.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomThumbView: UIView {
    
    fileprivate(set) var thumbImageView = UIImageView(frame: CGRect.zero)
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.thumbImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.thumbImageView)
        
    }
    
}

extension CustomThumbView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.thumbImageView.layer.cornerRadius = self.layer.cornerRadius
        self.thumbImageView.clipsToBounds = self.clipsToBounds
        
    }
    
}
