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
    private var isStart: Bool = false
    public var queueCount: Int {
        return self.alertArray.count
    }
    private override init() {}
    
    public func start() {
        if self.isStart {
            return
        }
        self.isStart = true
        self.processQueue()
    }

    public func addAlert(alertView: YXTopWindowView) {
        self.alertArray.append(alertView)
    }
    
    public func showAlert() {
        
        var index = -1
        var alertView: YXTopWindowView?
        for (i, alert) in alertArray.enumerated() {
            if alertView == nil || alert.tag < alertView!.tag {
                alertView = alert
                index = i
            }
        }
        
        alertView?.closeEvent = { [weak self] in
            self?.alertArray.remove(at: index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.showAlert()
            }
        }
        alertView?.show()
        
    }
    
    
    private func processQueue() {
        // 创建队列组
        let group = DispatchGroup()
        
        // 创建并发队列
        let queue = DispatchQueue.global()
        
        group.enter()
        queue.async(group: group) {
            YXAlertCheckManager.default.checkVersion {
                group.leave()
            }
        }
        
        group.enter()
        queue.async(group: group) {
            YXAlertCheckManager.default.checkOldUser {
                group.leave()
            }
        }
        
        group.enter()
        queue.async(group: group) {
            YXAlertCheckManager.default.checkCommand(isStartup: true) {
                group.leave()
            }
        }
        
        group.enter()
        queue.async(group: group) {
            YXAlertCheckManager.default.checkLatestBadge {
                group.leave()
            }
        }
        
        // 数据都处理完，才开始弹窗
        group.notify(queue: queue) { [weak self] in
            self?.showAlert()
        }
    }
    
}

