//
//  YXWordButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/2.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

class YXWordButton: UIButton {

    var status: YXButtonStatus = .normal {
        willSet {
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
                self.isEnabled         = false
                self.backgroundColor   = UIColor.white
                self.layer.borderColor = UIColor.red1.cgColor
                self.setTitleColor(UIColor.red1, for: .normal)
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
