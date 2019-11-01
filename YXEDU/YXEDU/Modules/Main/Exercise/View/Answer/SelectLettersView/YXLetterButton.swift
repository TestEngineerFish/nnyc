//
//  YXLetterButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXLetterButtonStatus {
    case normal
    case selected
    case error
    case right
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

    var status: YXLetterButtonStatus = .normal {
        willSet {
            switch newValue {
            case .normal:
                self.backgroundColor = UIColor.white
                self.setTitleColor(UIColor.black1, for: .normal)
                self.layer.borderColor = UIColor.black6.cgColor
                self.layer.borderWidth = 0.5
            case .selected:
                self.backgroundColor = UIColor.orange1
                self.setTitleColor(UIColor.white, for: .selected)
                self.layer.borderColor = UIColor.orange1.cgColor
                self.layer.borderWidth = 0.5
            case .error:
                self.backgroundColor = UIColor.white
                self.setTitleColor(UIColor.red1, for: .selected)
                self.layer.borderColor = UIColor.red1.cgColor
                self.layer.borderWidth = 0.5
            case .right:
                self.backgroundColor = UIColor.white
                self.setTitleColor(UIColor.green1, for: .selected)
                self.layer.borderColor = UIColor.green1.cgColor
                self.layer.borderWidth = 0.5
            }
        }
    }

    override var isSelected: Bool {
        willSet(value) {
            if value {
                self.status = .selected
            } else {
                self.status = .normal
            }
        }
    }
}
