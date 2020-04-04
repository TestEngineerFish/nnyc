//
//  YXButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXButtonStatusEnum: Int {
    case normal
    case touchDown
    case disable
}

enum YXButtonType: Int {
    /// 普通的按钮，无特殊样式
    case normal
    /// 主按钮，主题橙色渐变背景样式
    case theme
    /// 次按钮，主题橙色边框样式
    case border
}

@IBDesignable
class YXButton: UIButton {

    var status: YXButtonStatusEnum
    var type: YXButtonType

    // MARK: ---- 自定义属性 ----
    var cFont: UIFont?
    var cTextColor: UIColor?
    var cTextHeightColor: UIColor?
    var cBackgroundColor: UIColor?
    var cBorderColor: CGColor?
    var cBorderWidth: CGFloat?
    var cCornerRadius: CGFloat?

    // MARK: ---- 常量 ----
    let sizeKeyPath            = "size"
    let fontKeyPath            = "titleLabel.font"
    let textColorKeyPath       = "titleLabel.textColor"
    let textHeightColorKeyPath = "titleLabel.highlightedTextColor"
    let backgroundColorKeyPath = "titleLabel.backgroundColor"
    let borderColorKeyPath     = "borderColor"
    let borderWidthKeyPath     = "borderWidth"
    let cornerRadiuskeyPath    = "cornerRadius"

    // MARK: ---- Init ----

    init(_ type: YXButtonType = .normal, status: YXButtonStatusEnum = .normal, frame: CGRect = .zero) {
        self.status = status
        self.type   = type
        super.init(frame: frame)

        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.removeTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }

    // MARK: ---- Layout ----

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setStatus(nil)
        self.layer.cornerRadius  = self.size.height / 2
        self.layer.masksToBounds = true
    }

    /// 设置按钮状态，根据状态来更新UI
    func setStatus(_ status: YXButtonStatusEnum?) {
        if let _status = status {
          self.status = _status
        }
        switch self.status {
        case .normal:
            self.isEnabled = true
            switch type {
            case .normal:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.black1, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.black1, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.white
                }
            case .theme:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.white, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.white, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
                }
            case .border:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.clear
                }
            }
        case .touchDown:
            self.isEnabled = true
            switch type {
            case .normal:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.black1, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.black1, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.white
                }
            case .theme:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.white, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.white, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
                }
            case .border:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.clear
                }
            }
        case .disable:
            self.isEnabled = false
            switch type {
            case .normal:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.black1.withAlphaComponent(0.3), for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.black1.withAlphaComponent(0.3), for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.white
                }
            case .theme:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.hex(0xEAD2BA), for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.hex(0xEAD2BA), for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.hex(0xFFF4E9)
                }
            case .border:
                if let _color = self.cTextColor {
                    self.setTitleColor(_color, for: .normal)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .normal)
                }
                if let _color = self.cTextHeightColor {
                    self.setTitleColor(_color, for: .highlighted)
                } else {
                    self.setTitleColor(UIColor.orange1, for: .highlighted)
                }
                if let _color = self.cBackgroundColor {
                    self.backgroundColor = _color
                } else {
                    self.backgroundColor = UIColor.hex(0x0F0F0F).withAlphaComponent(0.09)
                }
            }
        }
    }

    // MARK: ---- Event ----
    private func bindProperty() {
        self.addObserver(self, forKeyPath: sizeKeyPath, options: .new, context: nil)
        self.addObserver(self, forKeyPath: fontKeyPath, options: .new, context: nil)
        self.addObserver(self, forKeyPath: textColorKeyPath, options: .new, context: nil)
        self.addObserver(self, forKeyPath: textHeightColorKeyPath, options: .new, context: nil)
        self.addObserver(self, forKeyPath: backgroundColorKeyPath, options: .new, context: nil)
        self.addObserver(self.layer, forKeyPath: borderColorKeyPath, options: .new, context: nil)
        self.addObserver(self.layer, forKeyPath: borderWidthKeyPath, options: .new, context: nil)
        self.addObserver(self.layer, forKeyPath: cornerRadiuskeyPath, options: .new, context: nil)
    }

    @objc func touchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.10) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    @objc func touchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform.identity
        }
    }

    //TODO: 自定义Storyboard编辑器
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
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

    // MARK: ---- KVO ----
    // 需要在setStatus中更新值
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _keyPath = keyPath else { return }
        switch _keyPath {
        case sizeKeyPath:
            self.layoutIfNeeded()
//        case fontKeyPath:
//            if let _button = object as? UIButton, let _font = _button.titleLabel?.font {
//                self.cFont = _font
//            }
//        case textColorKeyPath:
//            if let _button = object as? UIButton {
//                self.cTextColor = _button.currentTitleColor
//            }
//        case textHeightColorKeyPath:
//            if let _button = object as? UIButton, let _color = _button.titleLabel?.highlightedTextColor {
//                self.cTextHeightColor = _color
//            }
//        case backgroundColorKeyPath:
//            if let _button = object as? UIButton, let _color = _button.backgroundColor {
//                self.cBackgroundColor = _color
//            }
//        case borderColorKeyPath:
//            if let _button = object as? UIButton, let _color = _button.layer.borderColor {
//                self.cBorderColor = _color
//            }
//        case borderWidthKeyPath:
//            if let _button = object as? UIButton {
//                self.cBorderWidth = _button.layer.borderWidth
//            }
//        case cornerRadiuskeyPath:
//            if let _button = object as? UIButton {
//                self.cCornerRadius = _button.layer.cornerRadius
//            }
        default:
            break
        }
    }

}

