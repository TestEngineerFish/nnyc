//
//  YXNewLearnAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnAnswerView: YXBaseAnswerView {

    var resultView: YXLearnResultAnimationSubview?

    override func createSubview() {
        super.createSubview()
        self.backgroundColor = UIColor.gray1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.delegate?.switchQuestion()

        if resultView == nil {
            self.showFailAnimation()
        } else {
            self.hideFailAnimation()
        }
    }



    //MARK: TOOL

    private func showFailAnimation() {
        resultView = YXLearnResultAnimationSubview(1)
        self.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(85)
        })
        resultView?.showAnimation()
    }

    private func hideFailAnimation() {
        resultView?.hideAnimation()
    }
}
