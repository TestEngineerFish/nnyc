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
            // 学完，上报
            submitResult()
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
    
    
    //MARK: submit report
    /// 上报数据
    func submitResult() {
        dataManager.reportUnit(type: dataType, time: 0) { [weak self] (result, errorMsg) in
            guard let self = self else {return}
            if result {
                let progress = self.dataManager.progressManager.loadLocalWordsProgress()
                // 上报结束, 清空数据
                self.dataManager.progressManager.completionReport()
                
                switch self.dataType {
                case .normal:
                    self.processBaseExerciseResult(newCount: progress.0.count, reviewCount: progress.1.count)
                default:
                    self.processReviewResult()
                }
                
                print("学完")
            } else {
                UIView.toast("上报关卡失败")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    //MARK: process
    // 处理基本练习结果页
    func processBaseExerciseResult(newCount: Int, reviewCount: Int) {
        let vc = YXLearningResultViewController()
        vc.bookId = self.dataManager.bookId
        vc.unitId = self.dataManager.unitId
        vc.newLearnAmount = newCount
        vc.reviewLearnAmount = reviewCount
                            
        self.navigationController?.popViewController(animated: false)
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    
    /// 处理复习结果页
    func processReviewResult() {
        YXReviewDataManager().fetchReviewResult(type: dataType, planId: planId ?? 0) { [weak self] (resultModel, error) in
            guard let self = self else {return}
            
            if let model = resultModel {
                
                if self.dataType == .aiReview && model.planState != .finish {
                    self.processAIReviewProgressResult(model: model)
                } else {
                    self.processReviewResult(model: model)
                }
                                
            } else {
                YXUtils.showHUD(self.view, title: "上报关卡失败")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    /// 智能复习结果页
    /// - Parameter model:
    func processAIReviewProgressResult(model: YXReviewResultModel) {
        let aiView = YXReviewLearningProgressView()
        aiView.model = model
        aiView.show()
    }
    
    
    /// 听力复习结果页
    func processReviewResult(model: YXReviewResultModel) {
        let resultView = YXReviewResultView(type: dataType)
        resultView.model = model
        resultView.show()
    }
}
