//
//  YXAlertManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAlertManager {
    
    static let `default` = YXAlertManager()
    
    
    /// 检查停服状态
    func checkServiceState() {
        NotificationCenter.default.addObserver(self, selector: #selector(processServiceStop(notification:)), name: YXNotification.kServiceStop, object: nil)
    }
    
    
    /// 检查口令
    /// - Parameter isStart: 是否刚启动
    func checkCommand(isStartup: Bool) {
        if isStartup {
            YXBecomeActiveManager.default.startupCheck()
        } else {
            YXBecomeActiveManager.default.check()
        }
    }
    
    /// 检查版本
    func checkVersion() {
                
        let appVersion = UIDevice().appVersion()
        let key = YXLocalKey.updateVersionTips.rawValue
        if let cacheVersion = YYCache.object(forKey: key) as? String {
            if appVersion != cacheVersion {
                // 清空提示 【提示后，更了版本，再有新的版本，需要重新提示】
                YYCache.remove(forKey: key)
            }
        }
        
        
        YXSettingDataManager().checkVersion { (model, error) in
            if let versionModel = model {
                // 已经是最新版本
                if versionModel.state == .latest {
                    return
                }
                
                let alertView = YXAlertView()
                
                if versionModel.state == .recommend {
                    if let _ = YYCache.object(forKey: key) {
                        // 推荐更新，只提示一次
                        return
                    }
                    
                    // 保存提示状态
                    YYCache.set(appVersion, forKey: key)

                } else if versionModel.state == .force {
                    alertView.shouldOnlyShowOneButton = true
                }
                                                
                alertView.titleLabel.text = "版本更新"
                alertView.descriptionLabel.text = versionModel.content
                alertView.doneClosure = { (str) in
                    guard let url = URL(string: versionModel.url ?? "") else { return }
                    UIApplication.shared.open(url, options: [:]) { (result) in                        
                    }
                }
                
                alertView.show()
            }
        }

    }
    
    
    @objc private func processServiceStop(notification: Notification) {
        let alertView = YXAlertView()
        
        alertView.titleLabel.text = "念念有词正在进行维护"
        alertView.descriptionLabel.text = "请耐心等待，预计X小时后恢复"
        
        alertView.leftButton.isHidden = true
        alertView.rightOrCenterButton.isHidden = true
        alertView.shouldDismissWhenTapBackground = false
        
        alertView.show()
    }
    
}
