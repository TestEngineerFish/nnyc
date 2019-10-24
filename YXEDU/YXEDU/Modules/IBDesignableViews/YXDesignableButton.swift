//
//  YXConnerButton.swift
//  KouSuan
//
//  Created by Jake To on 10/14/19.
//  Copyright © 2019 sunwu. All rights reserved.
//

import UIKit

@IBDesignable
class YXDesignableButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            layer.shadowColor = shadowColor
        }
    }

    @IBInspectable
    var enableGradientBackground: Bool = false
     
    @IBInspectable
    var gradientColor1: UIColor = UIColor.black
     
    @IBInspectable
    var gradientColor2: UIColor = UIColor.white
     
    override func layoutSubviews() {
        super.layoutSubviews()
     
        if enableGradientBackground {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
