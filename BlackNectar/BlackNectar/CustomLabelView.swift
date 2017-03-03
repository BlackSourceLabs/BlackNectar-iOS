//
//  customLabelView.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/18/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomLabelView: UILabel {
    
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
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
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
    
    @IBInspectable var kearning: CGFloat = 0 {
        
        didSet {
            updateView()
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
        
        setKearning(self.kearning)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateView()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateView()
        
    }    
    
    
    private func setKearning(_ kearning: CGFloat) {
        
        var mutableText: NSMutableAttributedString
        
        if let attributedText = self.attributedText {
            
            mutableText = NSMutableAttributedString.init(attributedString: attributedText)
            
        }
        else {
            mutableText = NSMutableAttributedString.init(string: self.text ?? "")
        }
        
        mutableText.addAttribute(NSKernAttributeName, value: kearning, range: NSRange(location: 0, length: mutableText.length - 1))
        self.attributedText = mutableText
    }
}
