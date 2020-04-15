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
        if dataManager.dataStatus == .empty {
            processEmptyData()
        } else {
            // 没有数据，就是完成了练习
            dataManager.progressManager.completionExercise()

            dataManager.progressManager.setOneExerciseFinishStudyTime()
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
        YXLog("====上报数据====")
        dataManager.reportExercise(type: dataType) { [weak self] (result, errorMsg) in
            guard let self = self else {return}
            if result {
                // 统计打点
                self.biReport()
                
                let progress = self.dataManager.progressManager.loadLocalWordsProgress()
                // 上报结束, 清空数据
                self.dataManager.progressManager.completionReport()
                
                switch self.dataType {
                case .base:
                    YXGrowingManager.share.uploadLearnFinished()
                    // 记录学完一次主流程，用于首页弹出设置提醒弹框
                    YYCache.set(true, forKey: "DidFinishMainStudyProgress")
                    
                    self.processBaseExerciseResult(newCount: progress.0.count, reviewCount: progress.1.count)
                default:
                    self.processReviewResult()
                }
                
                YXLog("学完")
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
        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.popViewController(animated: false)
//        YRRouter.popViewController(false)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    
    /// 处理复习结果页
    func processReviewResult() {
        let vc = YXExerciseResultViewController()
        vc.dataType = dataType
        vc.planId   = planId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.popViewController(animated: false)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    
    
    /// 数据打点
    func biReport() {
        
        var typeName = "主流程"
        switch dataType {
            case .wrong:
                typeName = "抽查复习"
            case .planListenReview:
                typeName = "词单听写"
            case .planReview:
                typeName = "词单复习"
            case .aiReview:
                typeName = "智能复习"
            default:
                typeName = "主流程"
        }
        
        let bid = (YYCache.object(forKey: .currentChooseBookId) as? Int) ?? 0
        let grade = YXWordBookDaoImpl().selectBook(bookId: bid)?.gradeId ?? 0
        
        let studyResult: [String : Any] = [
            "study_grade" : "\(grade)",      //学习书本年级
            "study_cost_time" : dataManager.progressManager.fetchStudyDuration(),   //学习时间
            "study_count" : dataManager.progressManager.fetchStudyCount(),
            "study_type" : typeName
        ]
        Growing.track("study_result", withVariable: studyResult)
    }
    
    
}
