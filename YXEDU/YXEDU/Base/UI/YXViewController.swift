//
//  YXViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXViewController: UIViewController {
    
//    enum RequestStatus {
//        case loading
//        case finish
//    }
//    
//    var isMonitorNetwork: Bool = false {
//        didSet { setNetworkMonitor() }
//    }
//    
//    deinit {
//        print("资源释放", self.classForCoder)
//        
//        if isMonitorNetwork {
//            NotificationCenter.default.removeObserver(self, name: YWNotification.kNetwork, object: nil)
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        print("=============== 内存告警 ================")
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // 当使用自定义导航条的时候，左滑返回会消失，在扩展中进行了实现
//        self.navigationController?.delegate = self
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.white
//        
//        addCustomNavigationBar()
//        addNotification()
//    }
//    
//    
//    func addNotification() {
//        
//    }
//    
//    /** 子类可以重写该方法进行相应处理 */
//    func monitorNetwork() {}
//    
//    
//    func configureView() {}
//    
//}
//
//
//extension YXViewController {
//    private func setNetworkMonitor() {
//        if isMonitorNetwork {
//            NotificationCenter.default.addObserver(self, selector: #selector(monitorNetworkEvent(_:)), name: YWNotification.kNetwork, object: nil)
//        } else {
//            NotificationCenter.default.removeObserver(self, name: YWNotification.kNetwork, object: nil)
//        }
//    }
//    
//    @objc private func monitorNetworkEvent(_ notification: Notification) {
//        self.monitorNetwork()
//    }
}
