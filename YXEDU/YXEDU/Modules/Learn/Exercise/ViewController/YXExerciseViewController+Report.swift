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
            // 没有数据，就是完成了练习
//            dataManager.progressManager.completionExercise()

//            dataManager.progressManager.setOneExerciseFinishStudyTime()
            
            // 学完，上报
            submitResult()
        }
    }
    
        
    func processEmptyData() {
        service.cleanExercise()

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
        self.service.report { (result, dict) in
            if result {
                YXLog("上报关卡成功")
                if self.learnConfig.learnType == .base {
                    // 记录学完一次主流程，用于首页弹出设置提醒弹框
                    YYCache.set(true, forKey: "DidFinishMainStudyProgress")
                    let newWordCount    = dict["newWordCount"] ?? 0
                    let reviewWordCount = dict["reviewWordCount"] ?? 0
                    self.processBaseExerciseResult(newCount: newWordCount, reviewCount: reviewWordCount)
                } else {
                    self.processReviewResult()
                }
            } else {
                YXLog("上报关卡失败")
                UIView.toast("上报关卡失败")
                self.navigationController?.popViewController(animated: true)
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
//        self.navigationController?.popViewController(animated: false)
//        YRRouter.popViewController(false)
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



    /// 数据打点
//    func biReport() {
//
//        var typeName = "主流程"
//        switch learnConfig.learnType {
//            case .wrong:
//                typeName = "抽查复习"
//            case .planListenReview:
//                typeName = "词单听写"
//            case .planReview:
//                typeName = "词单复习"
//            case .aiReview:
//                typeName = "智能复习"
//            default:
//                typeName = "主流程"
//        }
//
//        let bid = (YYCache.object(forKey: .currentChooseBookId) as? Int) ?? 0
//        let grade = YXWordBookDaoImpl().selectBook(bookId: bid)?.gradeId ?? 0
//
//        let studyResult: [String : Any] = [
//            "study_grade" : "\(grade)",      //学习书本年级
//            "study_cost_time" : dataManager.progressManager.fetchStudyDuration(),   //学习时间
//            "study_count" : dataManager.progressManager.fetchStudyCount(),
//            "study_type" : typeName
//        ]
//        Growing.track("study_result", withVariable: studyResult)
//    }


}
