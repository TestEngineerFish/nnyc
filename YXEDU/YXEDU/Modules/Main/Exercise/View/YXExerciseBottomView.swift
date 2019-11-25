//
//  YXExerciseBottomView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXExerciseBottomViewProtocol {
    /// 点击提示一下按钮事件
    func clickTipsBtnEvent()
}

/// 练习模块：底部View
class YXExerciseBottomView: UIView {
    
    //MARK: - 私有属性
    var tipsButton = UIButton()

    var delegate: YXExerciseBottomViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red

        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(tipsButton)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        self.tipsButton.setTitle("提示一下", for: .normal)
        self.tipsButton.setImage(UIImage(named: "exercise_tips"), for: .normal)
        self.tipsButton.setTitleColor(UIColor.black3, for: .normal)
        self.tipsButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.tipsButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 12)
        self.tipsButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tipsButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.width.equalTo(100)
            make.height.equalTo(17)
        }
    }
    
    
    @objc func clickTipsButton() {
        self.delegate?.clickTipsBtnEvent()
    }
    
}
