//
//  YXConnectWordAndChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 连线题目， 1. 词义连线，2. 词图连线
class YXConnectionAnswerView: YXBaseAnswerView {

    var connectionView: YXConnectionView?
 
    override func createSubviews() {
        super.createSubviews()
        self.connectionView = YXConnectionView(exerciseModel: self.exerciseModel)
        let connectionHeight = connectionView!.itemConfig.rightItemHeight * 4 + connectionView!.itemConfig.rightInterval * 3 + 30
        connectionView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: connectionHeight)
        self.addSubview(connectionView!)
    }
    
    override func bindProperty() {
        self.backgroundColor = UIColor.clear
        
        connectionView!.connectionCompletion = {[weak self] in
            self?.answerCompletion(right: true)
        }
    }
    
    override func bindData() {
        self.connectionView?.exerciseModel = self.exerciseModel
    }
    
}