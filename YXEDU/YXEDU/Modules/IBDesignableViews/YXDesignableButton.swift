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
    
    lazy var enableLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        gradientLayer.startPoint = CGPoint(x: gradientColorStartPoint, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1 - gradientColorStartPoint, y: 1)
        return gradientLayer
    }()
    
    lazy var disableLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.91, alpha: 1).cgColor
        return layer
    }()
    
    lazy var touchedLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 0.2).cgColor
        return layer
    }()
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if canBeDisabled {
                adjustButtonState()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
     
        if enableShadow {
            
        }
        
        if canBeDisabled {
            adjustButtonState()

        } else {
            self.layer.insertSublayer(enableLayer, at: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        if enableGradientBackground, isUserInteractionEnabled {
//            self.layer.addSublayer(touchedLayer)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

//        if enableGradientBackground, isUserInteractionEnabled {
//            touchedLayer.removeFromSuperlayer()
//        }
    }
    
    private func adjustButtonState() {
        if enableGradientBackground {
            if isUserInteractionEnabled {
                disableLayer.removeFromSuperlayer()
                self.layer.insertSublayer(enableLayer, at: 0)
                self.setTitleColor(.white, for: .normal)
                
            } else {
                enableLayer.removeFromSuperlayer()
                self.layer.insertSublayer(disableLayer, at: 0)
                self.setTitleColor(UIColor(red: 0.92, green: 0.82, blue: 0.73, alpha: 1), for: .normal)
            }
        }
    }
    
    
    
    // MARK: - IBInspectable
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
    var gradientColor1: UIColor = UIColor(red: 0.99, green: 0.73, blue: 0.2, alpha: 1)
     
    @IBInspectable
    var gradientColor2: UIColor = UIColor(red: 0.98, green: 0.52, blue: 0.09, alpha: 1)
    
    @IBInspectable
    var gradientColorStartPoint: CGFloat = 0.5
    
    @IBInspectable
    var enableShadow: Bool = false
    
    @IBInspectable
    var canBeDisabled: Bool = true
}
