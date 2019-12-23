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
    public func check() {
        // 学习中，不要识别口令
        if let _ = YYCache.object(forKey: .learningState) {
            return
        }
        
        if let command = UIPasteboard.general.string, command.isNotEmpty {
            YXSettingDataManager().checkCommand(command: command) { (model, error) in
                if let commandModel = model {
                    let commandView = YXReviewPlanCommandView()
                    commandView.model = commandModel
                    commandView.show()
                    
                    commandView.detailEvent = {
                        self.goToReviewPlanDetail(planId: commandModel.planId, fromUser: commandModel.nickname)
                        commandView.removeFromSuperview()
                    }
                }
                
                UIPasteboard.general.string = ""
            }
        }
        
    }
    
    public func startupCheck() {
        if isStartUp {
            return
        }
        isStartUp = true
        
        check()
    }
    
    
    private func goToReviewPlanDetail(planId: Int, fromUser: String?) {
        let vc = YXReviewPlanShareDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.planId = planId
        vc.fromUser = fromUser
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
        
//        YRRouter.openURL("", query: ["plan_id" : planId], animated: true)
    }
}
