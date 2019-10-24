//
//  YXConnerButton.swift
//  KouSuan
//
//  Created by Jake To on 10/14/19.
//  Copyright © 2019 sunwu. All rights reserved.
//

import UIKit

@IBDesignable
class YXCustomButton: UIButton {

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

}
