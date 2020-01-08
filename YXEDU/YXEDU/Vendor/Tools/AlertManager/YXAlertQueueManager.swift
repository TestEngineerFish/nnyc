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

    public var processStatus = false
    public var queueCount: Int {
        return self.alertArray.count
    }
        
    private var alertArray: [YXTopWindowView] = []
    private var isStart: Bool = false
    private override init() {}
    
    // 在未知登陆状态下调用
    public func start() {
        if self.isStart {
            return
        }
        self.isStart = true
        self.processQueue()
    }
    
    // 登陆后再调用一次
    public func restart() {
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
        
        // 如果登陆过
        if YXUserModel.default.didLogin {
            group.enter()
            queue.async(group: group) {
                YXAlertCheckManager.default.checkOldUser {
                    print("====================== 检查老用户结束")
                    group.leave()
                }
            }
            
            group.enter()
            queue.async(group: group) {
                YXAlertCheckManager.default.checkCommand(isStartup: true) {
                    print("====================== 检查口令结束")
                    group.leave()
                }
            }
            
            group.enter()
            queue.async(group: group) {
                YXAlertCheckManager.default.checkLatestBadge {
                    print("====================== 检查最新徽章结束")
                    group.leave()
                }
            }
        }
        
        group.enter()
        queue.async(group: group) {
            YXAlertCheckManager.default.checkVersion {
                print("====================== 检查版本结束")
                group.leave()
            }
        }
        
        // 数据都处理完，才开始弹窗
        group.notify(queue: queue) { [weak self] in
            print("====================== 队列结束")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.processStatus = true
                self?.showAlert()
            }
        }
    }
    
}

