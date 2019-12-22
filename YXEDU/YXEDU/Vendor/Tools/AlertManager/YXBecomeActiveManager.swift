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
        
        if let command = UIPasteboard.general.string, command.isNotEmpty {
            YXSettingDataManager().checkCommand(command: command) { (model, error) in
                if let commandModel = model {
                    let commandView = YXReviewPlanCommandView()
                    commandView.model = commandModel
                    commandView.show()                    
                }
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
    
}
