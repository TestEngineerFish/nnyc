//
//  YXQuestionMeaningView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionMeaningView: UIView {
    let label: UILabel

    init(_ text: String) {
        label               = UILabel()
        label.text          = text
        label.font          = UIFont.pfSCRegularFont(withSize: 14)
        label.textColor     = UIColor.hex(0x888888)
        label.textAlignment = .center

        let height = CGFloat(20)
        let width  = text.textWidth(font: label.font, height: height)
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
