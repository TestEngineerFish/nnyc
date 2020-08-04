//
//  YXWordCharacterView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import SnapKit

enum YXCharTextFieldStatus: Int {
    case normal
    case error
    case right
}

enum YXCharTextFiledType: Int {
    case normal
    case blank
}

class YXLackWordView: UIView {
    let baseLineView = UIView()
    var textField: YXCharacterTextField
    var rightText    = ""
    var isTitle: Bool // 是否是主题Label

    var type: YXCharTextFiledType = .normal {
        willSet(newValue) {
            switch newValue {
            case .normal:
                self.baseLineView.isHidden = true
            case .blank:
                self.baseLineView.isHidden = false
            }
        }
    }

    var status: YXCharTextFieldStatus = .normal {
        willSet(value) {
            switch value {
            case .normal:
                self.textField.textColor = isTitle ? UIColor.black1 : UIColor.black2
            case .error:
                self.textField.textColor = UIColor.red1
            case .right:
                self.textField.textColor = UIColor.green1
            }
        }
    }

    var text: String {
        get {
            return self.textField.text ?? ""
        }
        set {
            self.textField.text = newValue
        }
    }

    init(frame: CGRect, isTitle: Bool) {
        self.isTitle = isTitle
        self.textField = YXCharacterTextField(frame: CGRect.zero, isTitle: isTitle)
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
        self.backgroundColor                       = .clear
        baseLineView.backgroundColor               = UIColor.hex(0xC0C0C0)
        self.isUserInteractionEnabled              = true
        self.textField.isUserInteractionEnabled    = false
        self.baseLineView.isUserInteractionEnabled = false
    }

    func clearValue() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) { [weak self] in
            guard let self = self else { return }
            if self.type == .blank {
                self.textField.text = ""
                self.status         = .normal
            }
        }
    }
}
