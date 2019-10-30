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
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        answerView?.snp.makeConstraints({ (make) in
//            make.centerX.bottom.equalToSuperview()
//            make.width.equalTo(screenWidth)
//            make.height.equalTo(223)
//        })
        
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
    }

    
    override func bindData() {
        
    }
}
