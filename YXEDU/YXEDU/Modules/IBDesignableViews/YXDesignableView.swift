//
//  YXCornerView.swift
//  KouSuan
//
//  Created by 沙庭宇 on 2019/10/15.
//  Copyright © 2019 sunwu. All rights reserved.
//
import UIKit

@IBDesignable
class YXDesignableView: UIView {

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
