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
        
        YXSettingDataManager().checkVersion { (model, error) in
            if let versionModel = model {
                // 已经是最新版本
                if versionModel.state == .latest {
                    completion?()
                    return
                }
                
                var alertView: YXAlertView?
                
                if versionModel.state == .recommend {
                    
                    let key = versionModel.latestVersion ?? ""
                    if let _ = YYCache.object(forKey: key) {
                        // 推荐更新，只提示一次
                        completion?()
                        return
                    }
                    // 保存提示状态
                    YYCache.set(key, forKey: key)
                    
                    alertView = YXAlertView()
                    alertView?.tag = YXAlertWeightType.recommendUpdateVersion
                } else if versionModel.state == .force {
                    alertView = YXAlertView()
                    alertView?.shouldClose = false
                    alertView?.shouldOnlyShowOneButton = true
                    alertView?.tag = YXAlertWeightType.updateVersion
                }
                
                alertView?.shouldDismissWhenTapBackground = false
                alertView?.titleLabel.text = "版本更新"
                alertView?.descriptionLabel.text = versionModel.content
                alertView?.doneClosure = { (str) in
                    guard let url = URL(string: versionModel.url ?? "") else { return }
                    UIApplication.shared.open(url, options: [:]) { (result) in                        
                    }
                }
                if let alert = alertView {
                    YXAlertQueueManager.default.addAlert(alertView: alert)
                }
                
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
            guard let userInfomation = response.data else {
                return
            }
            
            if userInfomation.oldUserUpdateMessage?.isNotEmpty ?? false {
                let alertView = YXOldUserUpdateView()
                alertView.closure = {
                    YXSettingDataManager().reportOldUserTips { (model, msg) in
                        YXLog("老用户更新提示，上报：", model?.state ?? 0)
                    }
                }
                
                YXAlertQueueManager.default.addAlert(alertView: alertView)
                completion?()
            } else {
                completion?()
            }
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?()
        }
        
    }
    
    /// 检查最新徽章
    func checkLatestBadge(_ completion: (() -> Void)? ) {
        // 没登录，不要识别口令
        if YXUserModel.default.didLogin == false {
            completion?()
            return
        }
        
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
            YXUtils.showHUD(kWindow, title: error.message)
            completion?()
        }
    }
    
    
    func checkLatestBadgeWhenBackTabPage() {
        if YXAlertQueueManager.default.queueCount == 0 && YXAlertQueueManager.default.processStatus {
            self.checkLatestBadge {
                YXAlertQueueManager.default.showAlert()
            }
        }
    }
    
    
    @objc private func processServiceStop(notification: Notification) {
        
        YXLog("停服打印：", notification.object ?? "--")
        
        let alertView = YXAlertView()
        
        alertView.titleLabel.text = "念念有词正在进行维护"
        alertView.descriptionLabel.text = (notification.object as? String) ?? "为了给您更好的体验，念念有词正在系统维护中，请稍后再试！"
        
        alertView.leftButton.isHidden = true
        alertView.rightOrCenterButton.isHidden = true
        alertView.shouldDismissWhenTapBackground = false
        alertView.tag = YXAlertWeightType.stopService
        
        YXAlertQueueManager.default.addAlert(alertView: alertView)
        YXAlertQueueManager.default.showAlert()
    }

    
}

