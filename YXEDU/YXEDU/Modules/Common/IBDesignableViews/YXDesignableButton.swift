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
        
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        layer.startPoint = CGPoint(x: gradientColorStartPoint, y: 0)
        layer.endPoint = CGPoint(x: 1 - gradientColorStartPoint, y: 1)
        return layer
    }()
    
    lazy var disableLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.91, alpha: 1).cgColor
        return layer
    }()
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            guard enableGradientBackground else { return }
            
            gradientLayer.removeFromSuperlayer()
            disableLayer.removeFromSuperlayer()

            if isUserInteractionEnabled {
                gradientLayer = {
                    let layer = CAGradientLayer()
                    layer.frame = self.bounds
                    layer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
                    layer.startPoint = CGPoint(x: gradientColorStartPoint, y: 0)
                    layer.endPoint = CGPoint(x: 1 - gradientColorStartPoint, y: 1)
                    return layer
                }()
                
                self.layer.insertSublayer(gradientLayer, at: 0)
                self.setTitleColor(originTextColor, for: .normal)
                
            } else {
                self.layer.insertSublayer(disableLayer, at: 0)
                self.setTitleColor(UIColor(red: 0.92, green: 0.82, blue: 0.73, alpha: 1), for: .normal)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
            
        if enableGradientBackground {
            let enabled = isUserInteractionEnabled
            isUserInteractionEnabled = enabled
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
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    
    
    // 漸變
    @IBInspectable
    var enableGradientBackground: Bool = false
     
    @IBInspectable
    var gradientColor1: UIColor = UIColor(red: 0.99, green: 0.73, blue: 0.2, alpha: 1)
     
    @IBInspectable
    var gradientColor2: UIColor = UIColor(red: 0.98, green: 0.52, blue: 0.09, alpha: 1)
    
    @IBInspectable
    var gradientColorStartPoint: CGFloat = 0.5
    
    @IBInspectable
    var originTextColor: UIColor = .white
}
