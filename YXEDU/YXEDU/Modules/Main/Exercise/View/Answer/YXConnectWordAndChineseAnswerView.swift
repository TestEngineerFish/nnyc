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

    override func createSubview() {
        super.createSubview()
        
        connectionView = YXConnectionView()
        let connectionHeight = YXConnectionView.Config.itemHeight * 4 + YXConnectionView.Config.interval * 3
        connectionView?.frame = CGRect(x: 0, y: 0, width: screenWidth - 22 * 2, height: connectionHeight)
        self.addSubview(connectionView!)
        
        self.bindProperty()
    }
    
//    override func layoutSubviews() {
//        
//    }
    
    func bindProperty() {
        self.connectionView?.exerciseModel = self.exerciseModel
    }

}
