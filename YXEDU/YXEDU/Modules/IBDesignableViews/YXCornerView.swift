//
//  YXCornerView.swift
//  KouSuan
//
//  Created by 沙庭宇 on 2019/10/15.
//  Copyright © 2019 sunwu. All rights reserved.
//
import UIKit

@IBDesignable
class YXCornerView: UIView {

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
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.insertSublayer(gradientLayer, at: 0)
            }
    }
}
