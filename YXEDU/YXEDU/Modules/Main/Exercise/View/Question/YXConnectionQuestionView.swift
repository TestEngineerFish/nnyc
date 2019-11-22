//
//  YXConnectionQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXConnectionQuestionView: YXBaseQuestionView {

    override func createSubviews() {
        self.backgroundColor = UIColor.clear
        super.createSubviews()
        let imageView = UIImageView(image: UIImage(named: "tips_connection"))
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
