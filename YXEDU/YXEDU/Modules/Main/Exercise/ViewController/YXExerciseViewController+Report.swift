//
//  YXExerciseViewController+Report.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/26.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseViewController {
    
    func report() {
                
        if dataManager.dataStatus == .empty {
            processEmptyData()
        } else {
            // 没有数据，就是完成了练习
            dataManager.progressManager.completionExercise()
                        
            switch dataType {
            case .normal:
                submitNormalResult()
            default:
                submitReviewResult()
            }
                                    
        }
        
    }
    
    
    
    func processEmptyData() {
        if dataType == .aiReview {
            let nrView = YXNotReviewWordView()
            nrView.doneEvent = {
                YRRouter.popViewController(true)
            }
            nrView.show()
        } else {
            YRRouter.popViewController(true)
        }
    }
    
    
    /// 上报正常练习数据
    func submitNormalResult() {
        // 学完，上报
        dataManager.reportUnit(type: dataType, time: 0) { [weak self] (result, errorMsg) in
            guard let self = self else {return}
            if result {
                let progress = self.dataManager.progressManager.loadLocalWordsProgress()
                // 上报结束, 清空数据
                self.dataManager.progressManager.completionReport()
                
                let vc = YXLearningResultViewController()
                vc.bookId = self.dataManager.bookId
                vc.unitId = self.dataManager.unitId
                vc.newLearnAmount = progress.0.count
                vc.reviewLearnAmount = progress.1.count
                                    
                self.navigationController?.popViewController(animated: false)
                vc.hidesBottomBarWhenPushed = true
                YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
            } else {
                YXUtils.showHUD(self.view, title: "上报关卡失败")
                self.navigationController?.popViewController(animated: true)
            }
            print("学完")
        }
    }
    
    
    /// 上报复习数据
    func submitReviewResult() {
        YXReviewDataManager().reportReviewResult(type: dataType, planId: 0) { [weak self] (resultModel, error) in
            guard let self = self else {return}
            
            if let model = resultModel {
                // 上报结束, 清空数据
                self.dataManager.progressManager.completionReport()
                
                if self.dataType == .aiReview && model.planState != .finish {
                    self.processAIReviewProgressResult(model: model)
                } else {
                    self.processReviewResult(model: model)
                }
                                
            } else {
                YXUtils.showHUD(self.view, title: "上报关卡失败")
                self.navigationController?.popViewController(animated: true)
            }
            print("学完")
                        
        }
    }
    
    func processAIReviewProgressResult(model: YXReviewResultModel) {
        let aiView = YXReviewLearningProgressView()
        aiView.model = model
        aiView.show()
    }
    
    
    func processReviewResult(model: YXReviewResultModel) {
        let resultView = YXReviewResultView(type: dataType)
        resultView.model = model
        resultView.show()
    }
}
