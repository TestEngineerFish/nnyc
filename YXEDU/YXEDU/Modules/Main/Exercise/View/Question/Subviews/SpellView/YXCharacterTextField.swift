//
//  YXCharacterTextField.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXCharacterTextField: UITextField, UIGestureRecognizerDelegate {

    var isBlank = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag                    = 999// 用户响应底部答题事件
        self.font                   = UIFont.boldSystemFont(ofSize: 20)
        self.textColor              = UIColor.hex(0x323232)
        self.borderStyle            = .none
        self.returnKeyType          = .done
        self.textAlignment          = .center
        self.inputAccessoryView     = UIView()
        self.autocorrectionType     = .no
        self.autocapitalizationType = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    // MARK: UIGestureRecognizerDelegate
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        return
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}
