//
//  YXCustomTextField.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import SnapKit

class YXCustomTextField: UIView {
    let baseLineView = UIView()
    let textField    = UITextField()

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
        textField.borderStyle = .none
    }


}
