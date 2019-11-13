//
//  YXQuestionImageView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionImageView: UIView {
    let imageView: YXKVOImageView

    init() {
        imageView = YXKVOImageView()
        super.init(frame: CGRect(x: 0, y: 0, width: AdaptSize(150), height: AdaptSize(108)))
        self.createUI()
    }

    private func createUI() {
        imageView.layer.cornerRadius = AdaptSize(5)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
