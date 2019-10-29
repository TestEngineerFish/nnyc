//
//  YXLookWordChooseImageExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/29.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXLookWordChooseImageExerciseView: YXBaseExerciseView {
    
    
    override func createSubview() {
        answerView = YXImageAnswerView()
        answerView?.exerciseModel = self.exerciseModel
        self.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(223)
        })
    }

    
    override func bindData() {
        
    }
}
