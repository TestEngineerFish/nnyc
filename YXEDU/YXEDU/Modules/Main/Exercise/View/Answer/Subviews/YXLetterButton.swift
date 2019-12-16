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
    var config: YXConnectionLettersConfig

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

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var status: YXButtonStatus = .normal {
        willSet {
            self.transform = .identity
            switch newValue {
            case .normal:
                self.isEnabled         = true
                self.backgroundColor   = config.backgroundNormalColor
                self.layer.borderColor = config.borderNormalColor.cgColor
                self.setTitleColor(config.textNormalColor, for: .normal)
                self.backgroundImageView.image = UIImage(named: "gameButtonNormal")
            case .selected:
                self.isEnabled         = true
                self.backgroundColor   = config.backgroundSelectedColor
                self.layer.borderColor = config.borderSelectedColor.cgColor
                self.setTitleColor(config.textSelectedColor, for: .normal)
                self.backgroundImageView.image = UIImage(named: "gameButtonSelected")
            case .error:
                self.isEnabled         = true
                self.backgroundColor   = config.backgroundErrorColor
                self.layer.borderColor = config.borderErrorColor.cgColor
                self.setTitleColor(config.textErrorColor, for: .normal)
                self.backgroundImageView.image = UIImage(named: "gameButtonError")
                self.layer.showBlowUpAnimation()
            case .right:
                self.isEnabled         = true
                self.backgroundColor   = config.backgroundRightColor
                self.layer.borderColor = config.borderRightColor.cgColor
                self.setTitleColor(config.textRightColor, for: .normal)
                self.backgroundImageView.image = UIImage(named: "gameButtonRight")
            case .disable:
                self.isEnabled         = false
                self.backgroundColor   = config.backgroundDisableColor
                self.layer.borderColor = config.borderDisableColor.cgColor
                self.setTitleColor(config.textDisableColor, for: .normal)
                self.backgroundImageView.image = UIImage(named: "gameButtonNormal")
            }
        }
    }

    init(config: YXConnectionLettersConfig = YXConnectionLettersConfig()) {
        self.config = config
        super.init(frame: CGRect.zero)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = CGFloat(14/20)
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.font = config.itemFont
        self.addSubview(backgroundImageView)
        self.sendSubviewToBack(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
