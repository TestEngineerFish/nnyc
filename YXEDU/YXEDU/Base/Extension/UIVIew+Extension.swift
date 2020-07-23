//
//  UIVIew+Extension.swift
//  YouYou
//
//  Created by pyyx on 2018/10/24.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

/**
 *  ViewGeometry
 */
public extension UIView {

    var top: CGFloat {
        get{
           return self.frame.origin.y
        }
        
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var left: CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get {
           return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get {
           return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue + self.frame.size.width
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var origin: CGPoint {
        get {
           return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}


extension UIView {
    
    fileprivate var bezierPathIdentifier:String { return "bezierPathBorderLayer" }
    
    fileprivate var bezierPathBorder:CAShapeLayer? {
        return (self.layer.sublayers?.filter({ (layer) -> Bool in
            return layer.name == self.bezierPathIdentifier && (layer as? CAShapeLayer) != nil
        }) as? [CAShapeLayer])?.first
    }
    
    func bezierPathBorder(_ color:UIColor = .white, width:CGFloat = 1) {
        
        var border = self.bezierPathBorder
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.layer.cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if (border == nil) {
            border = CAShapeLayer()
            border?.name = self.bezierPathIdentifier
            self.layer.addSublayer(border!)
        }
        
        border?.frame = self.bounds
        let pathUsingCorrectInsetIfAny =
            UIBezierPath(roundedRect: border!.bounds, cornerRadius:self.layer.cornerRadius)
        
        border?.path = pathUsingCorrectInsetIfAny.cgPath
        border?.fillColor = UIColor.clear.cgColor
        border?.strokeColor = color.cgColor
        border?.lineWidth = width * 2
        
    }
    
    func removeBezierPathBorder() {
        self.layer.mask = nil
        self.bezierPathBorder?.removeFromSuperlayer()
    }
}

extension UIView {
    
    /** 移除父视图上的所有子视图 */
    public func removeAllSubviews() {
        while (self.subviews.count > 0) {
            self.subviews.last?.removeFromSuperview()
        }
    }
}


extension UIView {
    
    /** 设置阴影 */
    public func configPathShadow(opacity: Float, radius: CGFloat, offset: CGSize, shadowColor: UIColor) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity //0.8，默认0，阴影透明度
        self.layer.shadowRadius = radius //8，阴影半径，默认3
        
        //切圆角
        self.layer.cornerRadius = radius
        
        //路径阴影
        //MARK: 宽高必须为 屏幕/self的宽高定，不能使用设置控件的bounds
        let path = UIBezierPath()
        let width = self.bounds.width - 30 //shadowV.bounds.width
        let height = self.bounds.height - 40 //shadowV.bounds.size.height
        let x = self.bounds.origin.x
        let y = self.bounds.origin.y
        
        let topLeft = self.bounds.origin
        let topRight = CGPoint.init(x: x + width, y: y)
        let bottomRight = CGPoint.init(x: x + width, y: y + height)
        let bottomLeft = CGPoint.init(x: x, y: y + height)
        
        let offset: CGFloat = 0.0
        path.move(to: CGPoint.init(x: topLeft.x - offset, y: topLeft.y - offset))
        path.addLine(to: CGPoint.init(x: topRight.x + offset, y: topRight.y - offset))
        path.addLine(to: CGPoint.init(x: bottomRight.x + offset, y: bottomRight.y + offset))
        path.addLine(to: CGPoint.init(x: bottomLeft.x - offset, y: bottomLeft.y + offset))
        path.addLine(to: CGPoint.init(x: topLeft.x - offset, y: topLeft.y - offset))
        
        //设置阴影路径
        self.layer.shadowPath = path.cgPath
        
    }
    
    /** 裁剪 view 的圆角 */
    public func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width:cornerRadius, height:cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }

    /// 根据需要,裁剪各个顶点为圆角
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter directionList: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    /// - note: .pi等于180度,圆角计算,默认以圆横直径的右半部分顺时针开始计算,当然如果参数 clockwies 设置false.则逆时针开始计算角度
    func clipRectCorner(directionList: [UIRectCorner], cornerRadius radius: CGFloat) {
        let bezierPath = UIBezierPath()
        // 以左边中间节点开始绘制
        bezierPath.move(to: CGPoint(x: 0, y: height/2))
        // 如果左上角需要绘制圆角
        if directionList.contains(.topLeft) {
            bezierPath.move(to: CGPoint(x: 0, y: radius))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint.zero)
        }
        // 如果右上角需要绘制
        if directionList.contains(.topRight) {
            bezierPath.addLine(to: CGPoint(x: right - radius, y: 0))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: 0))
        }
        // 如果右下角需要绘制
        if directionList.contains(.bottomRight) {
            bezierPath.addLine(to: CGPoint(x: width, y: height - radius))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        }
        // 如果左下角需要绘制
        if directionList.contains(.bottomLeft) {
            bezierPath.addLine(to: CGPoint(x: radius, y: height))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: height - radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: 0, y: height))
        }
        // 与开始节点闭合
        bezierPath.addLine(to: CGPoint(x: 0, y: height/2))

        let maskLayer   = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path  = bezierPath.cgPath
        layer.mask      = maskLayer
    }
}

// MARK: --- 颜色处理 ---
extension UIView {
    
    @discardableResult
    public func setGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint ,endPoint: CGPoint) -> CAGradientLayer {
        func setGradient(_ layer: CAGradientLayer) {
            self.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.bounds
            CATransaction.commit()
            
            layer.colors = colorArr
            layer.locations = locations
            layer.startPoint = startPoint
            layer.endPoint = endPoint
        }
        
        var kCAGradientLayerType = CAGradientLayerType.axial
        if let gradientLayer = objc_getAssociatedObject(self, &kCAGradientLayerType) as? CAGradientLayer {
            setGradient(gradientLayer)
            return gradientLayer
        } else {
            var gradientLayer = CAGradientLayer()
            self.layer.insertSublayer(gradientLayer , at: 0)
            setGradient(gradientLayer)
            objc_setAssociatedObject(self, &gradientLayer, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gradientLayer
        }
    }
    
}

extension UIView {
    /** 获取当前的 ViewController */
    public var currentViewController: UIViewController? {
        return YRRouter.sharedInstance().currentViewController()
    }

    /** 把当前 View 显示到顶层窗口上 */
    public func showTopWindow() {
        UIView.cleanTopWindow(anyClass: YXTopWindowView.classForCoder())
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    public class func cleanTopWindow(anyClass: AnyClass) {
        if let tviews = UIApplication.shared.keyWindow?.subviews {
            for tview in tviews {
                if tview.isKind(of: anyClass) {
                    tview.removeFromSuperview()
                }
            }
        }
    }
    
    /**
     * 显示Toast提示，基于当前的View，不影响其他页面的操作
     */
    public func toast(_ message: String?) {
        if let msg = message, msg.isNotEmpty {
            self.makeToast(msg, duration: 1.2, position: .center)
        }
    }
    
    /**
     * 显示Toast提示，基于最顶层，可能会影响其他的操作
     */
    public class func toast(_ msg: String?) {
        if let _msg = msg, _msg.isNotEmpty {
            if let topWindow = UIApplication.shared.windows.last {
                topWindow.toast(_msg)
            }
        }
    }
}

extension CGAffineTransform {
    var angle: CGFloat { return atan2(-self.c, self.a) }
    
    var angleInDegrees: CGFloat { return self.angle * 180 / .pi }
    
    var scaleX: CGFloat {
        let angle = self.angle
        return self.a * cos(angle) - self.c * sin(angle)
    }
    
    var scaleY: CGFloat {
        let angle = self.angle
        return self.d * cos(angle) + self.b * sin(angle)
    }
}


