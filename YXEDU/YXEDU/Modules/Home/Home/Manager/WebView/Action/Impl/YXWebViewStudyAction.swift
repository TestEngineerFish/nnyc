//
//  YXWebViewStudyAction.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewStudyAction: YRWebViewJSAction {
    override func action() {
        super.action()
        let vc = YXExerciseViewController()
        let bookId = YXUserModel.default.currentBookId ?? 0
        let unitId = YXUserModel.default.currentUnitId ?? 0
        vc.backAction = { (result: Bool) in
            guard let callBackStr = self.callback else {
                return
            }
            let resultDic = ["result":result]
            let funcStr = String(format: "%@('%@')", callBackStr, resultDic.toJson())
            DispatchQueue.main.async {
                self.jsBridge.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
            }
        }
        vc.learnConfig = YXBaseLearnConfig(bookId: bookId, unitId: unitId, homeworkId: 0)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
        
    }

}
