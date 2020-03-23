//
//  YXViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXViewController: UIViewController {
    
    // 是否监听网络变化
    var isMonitorNetwork: Bool = false {
        didSet { setNetworkMonitor() }
    }
    
    deinit {
        YXLog(self.classForCoder, "资源释放")

        if isMonitorNetwork {
            NotificationCenter.default.removeObserver(self, name: YXNotification.kNetwork, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        YXLog("=============== 内存告警 ================")
    }

    
    /// 状态栏默认为黑色字体，子类可以重写实现
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 当使用自定义导航条的时候，左滑返回会消失，在扩展中进行了实现
        self.navigationController?.delegate = self

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        addCustomNavigationBar()
        addNotification()
    }

    
    /// 添加通知，子类可实现
    func addNotification() {

    }

    /** 如果监听了网络变化，子类可以重写该方法进行相应处理 */
    func monitorNetwork(isReachable: Bool) {}


}


extension YXViewController {
    private func setNetworkMonitor() {
        if isMonitorNetwork {
            NotificationCenter.default.addObserver(self, selector: #selector(monitorNetworkEvent(_:)), name: YXNotification.kNetwork, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: YXNotification.kNetwork, object: nil)
        }
    }

    @objc private func monitorNetworkEvent(_ notification: Notification) {
        self.monitorNetwork(isReachable: YYNetworkService.default.isReachable)
    }
}
