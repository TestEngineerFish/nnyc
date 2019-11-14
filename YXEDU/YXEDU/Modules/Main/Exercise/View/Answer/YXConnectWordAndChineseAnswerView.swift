//
//  YXConnectWordAndChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 词义连线题目
class YXConnectWordAndChineseAnswerView: YXBaseAnswerView {

    var connectionView: YXConnectionView?

    override func createSubviews() {
        super.createSubviews()
        
        connectionView = YXConnectionView()
        let connectionHeight = YXConnectionView.Config.itemHeight * 4 + YXConnectionView.Config.interval * 3
        connectionView?.frame = CGRect(x: 22, y: 0, width: screenWidth - 22 * 2, height: connectionHeight)
        self.addSubview(connectionView!)
    }
    
    
    override func bindData() {
        self.connectionView?.exerciseModel = self.exerciseModel
    }

}
