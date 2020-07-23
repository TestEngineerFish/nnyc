//
//  UIFont+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

import UIKit.UIFont
/**
 *  IconFont
 */
public extension UIFont {
    @objc class func iconfont(size: CGFloat) -> UIFont? {
        return UIFont(name: "iconfont", size: size)
    }
}


public extension UIFont {
    
    private struct FontFamilyName {
        static let PingFangTCRegular: String = "PingFangSC-Regular"
        static let PingFangTCMedium: String = "PingFangSC-Medium"
        static let PingFangTCSemibold: String = "PingFangSC-Semibold"
        static let PingFangTCLight: String = "PingFangSC-Light"
        static let DINAlternateBold: String = "DINAlternate-Bold"
    }
    
    @objc class func regularFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCRegular, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    @objc class func mediumFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCMedium, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    @objc class func semiboldFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCSemibold, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    @objc class func lightFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.PingFangTCLight, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
    @objc class func DINAlternateBold(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: FontFamilyName.DINAlternateBold, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize:size)
        }
    }
    
}


