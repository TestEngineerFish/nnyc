//
//  YXQuestionImageView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionImageView: UIView {
    let imageView: UIImageView

    init(url urlStr: String) {
        imageView = UIImageView()
        super.init(frame: CGRect(x: 0, y: 0, width: 130, height: 94))
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.bindData(urlStr)
    }

    private func bindData(_ urlStr: String) {
        imageView.sd_setImage(with: URL(string: urlStr), completed: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
