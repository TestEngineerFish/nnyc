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
