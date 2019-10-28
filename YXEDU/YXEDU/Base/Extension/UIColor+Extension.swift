//
//  UIColor+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import CoreGraphics

public extension UIColor {
    class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }

    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如: 0x000fff
    /// - parameter alpha: 透明度
    class func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        if hex > 0xFFF {
            let divisor = CGFloat(255)
            let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hex & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hex & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let divisor = CGFloat(15)
            let red     = CGFloat((hex & 0xF00) >> 8) / divisor
            let green   = CGFloat((hex & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hex & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    /// 根据方向,设置渐变色
    ///
    /// - Parameters:
    ///   - size: 渐变区域大小
    ///   - colors: 渐变色数组
    ///   - direction: 渐变方向
    /// - Returns: 渐变后的颜色,如果设置失败,则返回nil
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    class func gradientColor(with size: CGSize, colors: [CGColor], direction: GradientDirectionType) -> UIColor? {
        switch direction {
        case .horizontal:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .vertical:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .leftTop:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .leftBottom:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter size: 渐变文字区域的大小.也就是用于绘制的区域
    /// - parameter colors: 渐变的颜色数组,从左到右顺序渐变,区域均匀分布
    /// - parameter startPoint: 渐变开始坐标
    /// - parameter endPoint: 渐变结束坐标
    /// - returns: 返回一个渐变的color,如果绘制失败,则返回nil;
    class func gradientColor(with size: CGSize, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        // 设置画布,开始准备绘制
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        // 获取当前画布上下文,用于操作画布对象
        guard let context     = UIGraphicsGetCurrentContext() else { return nil }
        // 创建RGB空间
        let colorSpaceRef     = CGColorSpaceCreateDeviceRGB()
        // 在RGB空间中绘制渐变色,可设置渐变色占比,默认均分
        guard let gradientRef = CGGradient(colorsSpace: colorSpaceRef, colors: colors as CFArray, locations: nil) else { return nil }
        // 设置渐变起始坐标
        let startPoint        = CGPoint.zero
        // 设置渐变结束坐标
        let endPoint          = CGPoint(x: size.width, y: size.height)
        // 开始绘制图片
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue | CGGradientDrawingOptions.drawsAfterEndLocation.rawValue))
        // 获取渐变图片
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return UIColor(patternImage: gradientImage)
    }

}
//MARK: **************** 颜色值 **********************
public extension UIColor {

    //MARK: 颜色快捷设置相关函数
    static func ColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func ColorWithHexRGBA(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.hex(hex, alpha: alpha)
    }
}
