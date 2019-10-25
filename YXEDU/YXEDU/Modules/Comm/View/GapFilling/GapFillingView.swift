//
//  GapFillingView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class GapFillingView: UIView {
    let questionView = QuestionView()
    let chooseView   = ChooseWordView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        self.createUI()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        addSubview(questionView)
        addSubview(chooseView)

        self.questionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(160)
        }
        self.chooseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionView.snp.bottom).offset(200)
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func bindProperty() {
        let wordsArray = ["e", "basfas", "longlong", "ssf", "s", "test", "testt", "e"]
        questionView.createUI()
        chooseView.createUI(wordsArray)
    }
    
}
