//
//  YXChallengeFooterView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeFooterView: UIView {

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF4EEE2)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(13))
            make.right.equalToSuperview().offset(AdaptSize(-13))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.top.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.clipRectCorner(directionList: [.bottomLeft, .bottomRight], cornerRadius: AdaptSize(14))
    }
}
