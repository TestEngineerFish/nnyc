//
//  YXExerciseViewController+Report.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/26.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import GrowingCoreKit
import GrowingAutoTrackKit

extension YXExerciseViewController {
    
    func report() {
        if service.progress == .empty {
            processEmptyData()
        } else {
            // 学完，上报
            submitResult()
        }
    }
    
        
    func processEmptyData() {
        service.cleanStudyRecord(hasNextGroup: false)

        if learnConfig.learnType == .aiReview {
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
        self.service.reportReport { (resultModel, dict) in
            guard let model = resultModel else {
                YXLog("上报关卡失败")
                UIView.toast("上报关卡失败")
                self.navigationController?.popViewController(animated: true)
                return
            }
            YXLog("上报关卡成功")
            if model.hasNextGroup {
                YXLog("还有下一组")
                self.showLoadAnimation()
                self.loadingView?.downloadCompleteBlock = {
                    self.startStudy(isGenerate: false)
                }
            } else {
                YXLog("没有下一组，进入结果页")
                if self.learnConfig.learnType == .base {
                    let newWordCount    = dict["newWordCount"] ?? 0
                    let reviewWordCount = dict["reviewWordCount"] ?? 0
                    self.processBaseExerciseResult(newCount: newWordCount, reviewCount: reviewWordCount)
                } else {
                    self.processReviewResult()
                }
            }
        }
    }
    
    //MARK: process
    // 处理基本练习结果页
    func processBaseExerciseResult(newCount: Int, reviewCount: Int) {
        let vc = YXLearningResultViewController()
        vc.bookId = service.learnConfig.bookId
        vc.unitId = service.learnConfig.unitId
        vc.newLearnAmount = newCount
        vc.reviewLearnAmount = reviewCount
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    
    /// 处理复习结果页
    func processReviewResult() {
        let vc = YXExerciseResultViewController()
        vc.dataType = learnConfig.learnType
        vc.planId   = learnConfig.planId 
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.popViewController(animated: false)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
