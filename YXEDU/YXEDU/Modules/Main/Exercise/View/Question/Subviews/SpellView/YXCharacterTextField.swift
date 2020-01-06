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

    init(frame: CGRect, isTitle: Bool) {
        super.init(frame: frame)
        self.tag                    = 999// 用户响应底部答题事件
        self.font                   = isTitle ? UIFont.boldSystemFont(ofSize: AdaptSize(26)) : UIFont.pfSCRegularFont(withSize: 16)
        self.textColor              = isTitle ? UIColor.black1 : UIColor.black2
        self.borderStyle            = .none
        self.returnKeyType          = .done
        self.textAlignment          = .center
        self.backgroundColor        = .clear
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
