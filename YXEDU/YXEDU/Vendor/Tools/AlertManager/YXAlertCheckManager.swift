//
//  YXAlertManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAlertCheckManager {
    
    static let `default` = YXAlertCheckManager()
    
    
    /// 检查停服状态
    func checkServiceState() {
        NotificationCenter.default.addObserver(self, selector: #selector(processServiceStop(notification:)), name: YXNotification.kServiceStop, object: nil)
    }
    
    
    /// 检查口令
    /// - Parameter isStart: 是否刚启动
    func checkCommand(isStartup: Bool, _ completion: (() -> Void)? ) {
        if isStartup {
            YXBecomeActiveManager.default.startupCheck(completion)
        } else {
            YXBecomeActiveManager.default.check(completion)
        }
    }
    
    /// 检查版本
    func checkVersion(_ completion: (() -> Void)? ) {
                
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
                    completion?()
                    return
                }
                
                let alertView = YXAlertView()
                
                if versionModel.state == .recommend {
                    if let _ = YYCache.object(forKey: key) {
                        // 推荐更新，只提示一次
                        completion?()
                        return
                    }
                    
                    // 保存提示状态
                    YYCache.set(appVersion, forKey: key)
                    alertView.tag = YXAlertWeightType.recommendUpdateVersion
                } else if versionModel.state == .force {
                    alertView.shouldOnlyShowOneButton = true
                    alertView.tag = YXAlertWeightType.updateVersion
                }
                                                
                alertView.titleLabel.text = "版本更新"
                alertView.descriptionLabel.text = versionModel.content
                alertView.doneClosure = { (str) in
                    guard let url = URL(string: versionModel.url ?? "") else { return }
                    UIApplication.shared.open(url, options: [:]) { (result) in                        
                    }
                }
                
                YXAlertQueueManager.default.addAlert(alertView: alertView)
                completion?()
            } else {
                completion?()
            }
        }

    }
    
    
    
    
    /// 老用户提示
    func checkOldUser(_ completion: (() -> Void)? ) {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let userInfomation = response.data, userInfomation.oldUserUpdateMessage?.isNotEmpty ?? false else {
                completion?()
                return
            }
            
            let alertView = YXAlertView()
            alertView.titleLabel.text = "版本更新"
            alertView.descriptionLabel.text = userInfomation.oldUserUpdateMessage
            alertView.shouldOnlyShowOneButton = true
            alertView.tag = YXAlertWeightType.oldUserTips
            alertView.doneClosure = { (string) in
                YXSettingDataManager().reportOldUserTips { (model, msg) in
                    print("老用户更新提示，上报：", model?.state ?? 0)
                }
            }
            
            YXAlertQueueManager.default.addAlert(alertView: alertView)
            completion?()
        }) { error in
            print("❌❌❌\(error)")
            completion?()
        }
        
    }
    
    /// 检查最新徽章
    func checkLatestBadge(_ completion: (() -> Void)? ) {
        let request = YXMineRequest.latestBadge
        YYNetworkService.default.request(YYStructDataArrayResponse<YXBadgeModel>.self, request: request, success: { (response) in
            guard let badgeList = response.dataArray, badgeList.count > 0 else {
                completion?()
                return                
            }
            
            for badge in badgeList {
                let badgeDetailView = YXBadgeDetailView(badge: badge, didCompleted: true)
                badgeDetailView.tag = YXAlertWeightType.latestBadge
                badgeDetailView.isReport = true
                YXAlertQueueManager.default.addAlert(alertView: badgeDetailView)
            }
            completion?()
        }) { error in
            print("❌❌❌\(error)")
            completion?()
        }
    }
    
    
    func checkLatestBadgeWhenBackTabPage() {
        if YXAlertQueueManager.default.queueCount == 0 {
            self.checkLatestBadge {
                YXAlertQueueManager.default.showAlert()
            }
        }
    }
    
    
    @objc private func processServiceStop(notification: Notification) {
        
        let alertView = YXAlertView()
        
        alertView.titleLabel.text = "念念有词正在进行维护"
        alertView.descriptionLabel.text = notification.object as? String
        
        alertView.leftButton.isHidden = true
        alertView.rightOrCenterButton.isHidden = true
        alertView.shouldDismissWhenTapBackground = false
        alertView.tag = YXAlertWeightType.stopService
        
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }

    
}
