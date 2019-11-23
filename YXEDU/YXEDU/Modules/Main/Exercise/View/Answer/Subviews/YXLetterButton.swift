//
//  YXLetterButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXButtonStatus {
    case normal
    case selected
    case error
    case right
    case disable
}

class YXLetterButton: UIButton {
    /// 默认占一个单元位置
    var widthUnit = 1

    /// 按钮上显示文案赋值,如果超过4个字符,则占位2个单元
    var text: String? {
        willSet(value) {
            self.setTitle(value, for: .normal)
            if (value ?? "").count > 4 {
                widthUnit = 2
            } else {
                widthUnit = 1
            }
        }
    }

    var status: YXButtonStatus = .normal {
        willSet {
            self.transform = .identity
            switch newValue {
            case .normal:
                self.isEnabled         = true
                self.backgroundColor   = UIColor.white
                self.layer.borderColor = UIColor.black6.cgColor
                self.setTitleColor(UIColor.black1, for: .normal)
            case .selected:
                self.isEnabled         = true
                self.backgroundColor   = UIColor.orange1
                self.layer.borderColor = UIColor.orange1.cgColor
                self.setTitleColor(UIColor.white, for: .normal)
            case .error:
                self.isEnabled         = true
                self.backgroundColor   = UIColor.white
                self.layer.borderColor = UIColor.red1.cgColor
                self.setTitleColor(UIColor.red1, for: .normal)
                self.showBlowUpAnimation()
            case .right:
                self.isEnabled         = false
                self.backgroundColor   = UIColor.white
                self.layer.borderColor = UIColor.green1.cgColor
                self.setTitleColor(UIColor.green1, for: .normal)
            case .disable:
                self.isEnabled         = false
                self.backgroundColor   = UIColor.white
                self.layer.borderColor = UIColor.black6.cgColor
                self.setTitleColor(UIColor.black6, for: .normal)
            }
        }
    }

    private func showBlowUpAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration       = 0.15
        animation.repeatCount    = 3
        animation.autoreverses   = true
        animation.tensionValues  = [1.0, 1.15, 1.0]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = true
        self.layer.add(animation, forKey: "showBlowUpAnimation")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = CGFloat(14/20)
        self.titleLabel?.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth  = 0.5
        self.layer.cornerRadius = 8.0
    }
}
