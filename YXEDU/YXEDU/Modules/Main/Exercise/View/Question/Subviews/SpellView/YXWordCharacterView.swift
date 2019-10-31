//
//  YXWordCharacterView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import SnapKit

enum YXCharTextFieldType: Int {
    case normal
    case blank
    case error
}

class YXWordCharacterView: UIView {
    let baseLineView = UIView()
    let textField    = YXCharacterTextField()

    var type: YXCharTextFieldType = .normal {
        willSet(value) {
            switch value {
            case .normal:
                self.textField.textColor   = UIColor.hex(0x323232)
                self.baseLineView.isHidden = true
            case .blank:
                self.textField.textColor   = UIColor.hex(0x323232)
                self.baseLineView.isHidden = false
            case .error:
                self.textField.textColor   = UIColor.hex(0xFF532B)
                self.baseLineView.isHidden = false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        addSubview(baseLineView)
        addSubview(textField)

        baseLineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        baseLineView.backgroundColor = UIColor.hex(0xC0C0C0)
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        self.addGestureRecognizer(tap)
    }

    // MARK: Event

    @objc private func tapView(_ sender: UITapGestureRecognizer) {

    }
}
