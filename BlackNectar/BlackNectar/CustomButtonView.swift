//
//  RoundedButtonView.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 12/8/16.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomButtonView: UIButton {
    
    private var label: UILabel? { return titleLabel }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        super.init(coder: aDecoder)
    
    }
    
    override func prepareForInterfaceBuilder() {
       
        updateView()
   
    }
   
    @IBInspectable var circular: Bool = false {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shouldRasterize: Bool = false {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOffSet: CGSize = CGSize(width: 3, height: 0) {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var numberOfLines: Int = 1 {
        
        didSet {
            
            if numberOfLines < 1 {
                numberOfLines = 1
            }
            
            updateView()
        }
    }
    
    @IBInspectable var enableAutoShrink: Bool = false {
        
        didSet {
            
            label?.adjustsFontSizeToFitWidth = enableAutoShrink
        }
    }
    
    @IBInspectable var minimumFontScaleFactor: CGFloat = 1.0 {
        
        didSet {
            
            if enableAutoShrink {
                label?.minimumScaleFactor = minimumFontScaleFactor
            }
            else {
                label?.minimumScaleFactor = 1.0
            }
            
        }
    }
    
    func updateView() {
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        
        if shouldRasterize {
            
            layer.rasterizationScale = UIScreen.main.scale
        
        }
        
        if let label = self.titleLabel {
            
            label.numberOfLines = self.numberOfLines
            
            if numberOfLines > 1 {
                label.lineBreakMode = .byWordWrapping
            }
            else {
                label.lineBreakMode = .byTruncatingTail
            }
            
        }
        
        self.imageView?.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateView()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateView()
        
    }
    
}
