//
//  YXNewLearnJuniorHighSchoolQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnJuniorHighSchoolQuestionView: YXBaseQuestionView {

    override func createSubviews() {
        super.createSubviews()
        guard let wordModel = self.exerciseModel.word else {
            return
        }
        let wordDetailView = YXWordDetailCommonView(frame: CGRect.zero, word: wordModel)
        wordDetailView.recordButton.isHidden = false
        self.addSubview(wordDetailView)
        wordDetailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        wordDetailView.autoPlay()
        self.layer.removeShadow()
    }
}
