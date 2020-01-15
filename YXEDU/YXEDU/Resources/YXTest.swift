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
            let random = Int.random(in: 0..<10)
            if random % 2 == 0 {
                // 人造崩溃
    //                let array = [1, 2, 3]
    //                print(array[5])
            }
            
//            self.processReviewResult()
            self.processBaseExerciseResult()
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
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
     /// 处理复习结果页
    func processReviewResult() {
        YXReviewDataManager().fetchReviewResult(type: .aiReview, planId: 13) { [weak self] (resultModel, error) in
            guard let self = self else {return}

            if var model = resultModel {

//                model.planId = 13
//                if model.planState {
//                    self.processReviewResult(model: model)
//                } else {
////                    self.processReviewProgressResult(model: model)
//                }
//                self.processReviewProgressResult(model: model)
                
//                self.processReviewResult(model: model)
                self.newResultVC(model: model)
            } else {
//                UIView.toast("上报关卡失败")
//                self.navigationController?.popViewController(animated: true)
            }

        }
    }

        /// 听力复习结果页
        func processReviewResult(model: YXReviewResultModel) {

            let vc = YXReviewResultViewController(type: .aiReview, model: model)
            vc.hidesBottomBarWhenPushed = true
            YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
        }
    
    
    /// 智能复习结果页
    /// - Parameter model:
    func processReviewProgressResult(model: YXReviewResultModel) {
        let progressView = YXReviewLearningProgressView(type: .planListenReview, model: model)
        progressView.reviewEvent = {
            let vc = YXExerciseViewController()
            vc.dataType = progressView.model?.type ?? .aiReview
            vc.planId = model.planId
            vc.hidesBottomBarWhenPushed = true
            YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
        }
        progressView.show()
    }
    
    
    func newResultVC(model: YXReviewResultModel) {
        let m = YXExerciseResultDisplayModel.displayModel(model: model)
        let vc = YXExerciseResultViewController(model: m)
        
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
