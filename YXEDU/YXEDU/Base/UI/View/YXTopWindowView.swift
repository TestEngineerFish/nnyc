//
//  YXTopWindowView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXAlertWeightType {
    static let stopService = 0         // A
    static let updateVersion = 1       // B
    static let oldUserTips = 2         // C
    static let recommendUpdateVersion = 2  // C
    static let scanCommand = 3             // D
    static let latestBadge = 4         // E
}


/**
 * 所有需要显示到最顶层的页面，必须继承自该View
 */
class YXTopWindowView: YXView {
    
    var closeEvent: (() -> Void)?
    
    var weightType: Int = YXAlertWeightType.stopService
    var mainView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mainView)
        mainView.backgroundColor = UIColor.white
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 6
        
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func removeFromSuperview() {
        self.closeEvent?()
        super.removeFromSuperview()
    }
}
