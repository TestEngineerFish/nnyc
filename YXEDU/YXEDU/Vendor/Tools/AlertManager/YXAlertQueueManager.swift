//
//  YXAlertListManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 弹窗队列管理
class YXAlertQueueManager: NSObject {
        
    static var `default` = YXAlertQueueManager()
        
    private var alertArray: [YXTopWindowView] = []
    private var isShowing: Bool = false
    private override init() {}

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    public func addAlert(alertView: YXTopWindowView) {
        self.alertArray.append(alertView)
        if !isShowing {
            self.showAlert()
        }
    }
    /// 添加一组alertView
    /// - Parameter alertViewList: alert对象组
    public func addAlertList(alertViewList: [YXTopWindowView]) {
        self.alertArray += alertViewList
        if !isShowing {
            self.showAlert()
        }
    }
    
    public func showAlert() {
        // 队列可能随时有新的对象插入，所以每次弹框需过滤和排序
        self.isShowing = true
        // 过滤已显示过的弹框
        self.alertArray = self.alertArray.filter { (alertView) -> Bool in
            return !alertView.isShowed
        }
        // 如果都展示结束，则弹框队列结束
        if self.alertArray.isEmpty {
            self.isShowing = false
            self.alertArray.removeAll()
            return
        }
        // 按优先级排序
        let alertView = self.alertArray.sorted { return $0.priority.rawValue < $1.priority.rawValue }.first

        alertView?.closeEvent = { [weak self] alert in
            guard let self = self else { return }
            alertView?.isShowed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showAlert()
            }
        }
        alertView?.show()
        
    }
    
    
    public func processQueue() {
        YXAlertCheckManager.default.checkVersion {
            YXLog("====================== 检查版本结束")
        }
        // 如果登录过
        if YXUserModel.default.didLogin {
            YXAlertCheckManager.default.checkOldUser {
                YXLog("====================== 检查老用户结束")
            }
            YXAlertCheckManager.default.checkCommand(isStartup: true) {
                YXLog("====================== 检查口令结束")
            }
            YXAlertCheckManager.default.checkHomework {
                YXLog("====================== 检查作业提醒结束")
            }
        }
    }
    
}

