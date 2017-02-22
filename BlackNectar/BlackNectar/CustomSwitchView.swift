//
//  CustomSwitchView.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/17/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class customSwitch: UIControl {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    @IBInspectable public var isOn: Bool = true
    public var animationDuration: Double = 0.5
    
    @IBInspectable public var padding: CGFloat = 1 {
        didSet {
            
            self.layoutSubviews()
        }
    }
    
    @IBInspectable public var onTintColor = Colors.fromRGB(red: 235, green: 191, blue: 77) {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var offTintColor = Colors.fromRGB(red: 216, green: 216, blue: 216) {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5 {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbCornerRadius: CGFloat = 5 {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbSize: CGSize = CGSize.zero {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbShadowColor: UIColor = UIColor.black {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbShadowRadius: CGFloat = 1.5 {
        didSet {
            
            
        }
    }
    
    @IBInspectable public var thumbShadowOpacity: Float = 0.4 {
        didSet {
            
            
        }
    }
    
    fileprivate var thumbView = CustomThumbView(frame: CGRect.zero)
    
    func updateView() {
        
        self.clipsToBounds = false
        
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        
        self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        self.thumbView.layer.shadowRadius = self.thumbShadowRadius
        self.thumbView.layer.shadowOpacity = self.thumbShadowOpacity
        self.thumbView.layer.shadowOffset = self.thumbShadowOffset
        
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        
        self.addSubview(self.thumbView)
        
    }
    

}
