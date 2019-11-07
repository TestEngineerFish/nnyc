//
//  YXDesignableLabel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

@IBDesignable
class YXDesignableLabel: UILabel {
    
    @IBInspectable
    var shadowOffsetOfLabel: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetOfLabel
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
    var shadowColorOfLabel: UIColor? {
        didSet {
            layer.shadowColor = shadowColorOfLabel?.cgColor
        }
    }
}
