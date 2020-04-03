//
//  YXBecomeManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBecomeActiveManager: NSObject {
    
    static let `default` = YXBecomeActiveManager()
    
    private var isStartUp: Bool = false
    /**
     * 检测口令 [回到前台时]
     * @params startUp  是否刚启动
     */
    public func check(_ completion: (() -> Void)? ) {
        // 学习中，不要识别口令
        if let _ = YYCache.object(forKey: .learningState) {
            YXLog("学习中----不检测口令")
            completion?()
            return
        }
        // 没登录，不要识别口令
        if YXUserModel.default.didLogin == false {
            YXLog("未登录----不检测口令")
            completion?()
            return
        }
        if let command = UIPasteboard.general.string, command.isNotEmpty {
            YXSettingDataManager().checkCommand(command: command) { (model, error) in
                if let commandModel = model {
                    let commandView = YXReviewPlanCommandView(model: commandModel)
                    commandView.tag = YXAlertWeightType.scanCommand
                    commandView.detailEvent = {
                        self.goToReviewPlanDetail(planId: commandModel.planId, fromUser: commandModel.nickname)
                        commandView.removeFromSuperview()
                    }
                    
                    if completion == nil {
                        commandView.show()
                    } else {
                        YXAlertQueueManager.default.addAlert(alertView: commandView)
                        completion?()
                    }
                } else {
                    completion?()
                }
                
                UIPasteboard.general.string = ""
            }
        } else {
            completion?()
        }
        
    }
    
    public func startupCheck(_ completion: (() -> Void)? ) {
        if isStartUp {
            completion?()
            return
        }
        isStartUp = true
        
        check(completion)
    }
    
    
    private func goToReviewPlanDetail(planId: Int, fromUser: String?) {
        let vc = YXReviewPlanShareDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.planId = planId
        vc.fromUser = fromUser
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
        
//        YRRouter.openURL("", query: ["plan_id" : planId], animated: true)
    }
}
