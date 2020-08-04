//
//  UIImageView+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/4.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension UIImageView {
    func clipCorner(radius: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        UIGraphicsGetCurrentContext()?.addPath(path)
        UIGraphicsGetCurrentContext()?.clip()
        self.draw(self.bounds)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    func clipCorner2(radius: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, .zero)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: self.bounds)
        context?.clip()
        self.image?.draw(in: self.bounds)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

