//
//  YXTopWindowView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
/// 优先级由高到低
enum YXAlertPriorityEnum: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case normal = 100
}

/**
 * 所有需要显示到最顶层的页面，必须继承自该View
 */
class YXTopWindowView: YXView {
    
    var closeEvent: ((YXTopWindowView) -> Void)?
    
    // 是否允许关闭窗口，默认 true，强制更新时，不能关闭窗口
    var shouldClose: Bool = true
    /// 优先级
    var priority = YXAlertPriorityEnum.normal
    /// 是否已展示过
    var isShowed = false

    var mainView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mainView)
        mainView.backgroundColor = UIColor.white
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius  = 6
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
        self.closeEvent?(self)
        super.removeFromSuperview()
    }
}
