//
//  YXTest.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXTest: NSObject {
    static let `default` = YXTest()
    
    func test() {
        #if DEBUG
        testA()
        #endif
    }
    
    func testA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let random = Int.random(in: 0..<10)
//            if random % 2 == 0 {
                // 人造崩溃
//                let array = [1, 2, 3]
//                YXLog(array[5])
//            }
            self.newResultVC()
//            self.processReviewResult()
//            self.processBaseExerciseResult()
        }
    }
    
    //MARK: process
    // 处理基本练习结果页
    func processBaseExerciseResult() {
        let vc = YXLearningResultViewController()
        vc.bookId = 41
        vc.unitId = 436
        vc.newLearnAmount = 10
        vc.reviewLearnAmount = 5
                            
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
     /// 处理复习结果页
    func processReviewResult() {
        YXReviewDataManager().fetchReviewResult(type: .aiReview, planId: 13) { (resultModel, error) in
//            guard let self = self else {return}

            if let _ = resultModel {
//                self.newResultVC(model: model)
            } else {
                UIView.toast("结果页，Test数据失败")
            }

        }
    }

    
    
    func newResultVC() {
//        let m = YXExerciseResultDisplayModel.displayModel(model: model)
        let vc = YXExerciseResultViewController()
        vc.dataType = .aiReview
        vc.planId = 13
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
