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
    
    private var animationDuration = 2.0
    
    private var startingValue: Float = 0
    private var destinationValue: Float = 0
    private var progress: TimeInterval = 0
    
    private var lastUpdateTime: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    
    private var timer: CADisplayLink?
    
    private var symbol: String?
    private var currentValue: Float {
        if progress >= totalTime { return destinationValue }
        return startingValue + Float(progress / totalTime) * (destinationValue - startingValue)
    }
    
    private func addDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }
    
    @objc private func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdateTime
        lastUpdateTime = now
        
        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }
        
        setTextValue(value: currentValue)
    }
    
    private func setTextValue(value: Float) {
        text = String(format: "\(symbol ?? "")%.0f", value)
    }
}



extension YXDesignableLabel {
    func count(from: Float, to: Float, duration: TimeInterval? = nil, anySymbol: String? = nil) {
        startingValue = from
        destinationValue = to
        
        timer?.invalidate()
        timer = nil
        
        if (duration == 0.0) {
            // No animation
            setTextValue(value: to)
            return
        }
        
        progress = 0.0
        totalTime = duration ?? animationDuration
        lastUpdateTime = Date.timeIntervalSinceReferenceDate
        
        symbol = anySymbol
        addDisplayLink()
    }
    
    func countFromCurrent(to: Float, duration: TimeInterval? = nil, anySymbol: String? = nil) {
        count(from: currentValue, to: to, duration: duration ?? nil, anySymbol: anySymbol)
    }
}
