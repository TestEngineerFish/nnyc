//
//  YXExerciseViewController+Report.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/26.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func report() {
//     YXReviewDataManager   reportReviewResult
        
        
        if dataManager.dataStatus == .empty {
            
            if dataType == .aiReview {
                let nrView = YXNotReviewWordView()
                nrView.doneEvent = {
                    YRRouter.popViewController(true)
                }
                nrView.show()
            } else {
                YRRouter.popViewController(true)
            }
            
        } else {
            // 没有数据，就是完成了练习
            dataManager.progressManager.completionExercise()
            
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
        
    }
    
    
    
    func processEmptyData() {
        
    }
    
}
