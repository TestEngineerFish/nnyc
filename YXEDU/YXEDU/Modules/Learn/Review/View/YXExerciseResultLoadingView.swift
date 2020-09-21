//
//  YXExerciseResultLoadingView.swift
//  YXEDU
//
//  Created by sunwu on 2020/2/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXExerciseResultLoadingView: YXView, CAAnimationDelegate {
    
    var clickEvent: (() -> Void)?
    var titleLabel = UILabel()
    var resultView = AnimationView(name: "resultLoading")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(resultView)
        self.addSubview(titleLabel)
    }
    
    override func bindProperty() {
        titleLabel.text = "正在生成报告…"
        titleLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(13))
        titleLabel.textColor = UIColor.black3
    }
    
    override func layoutSubviews() {
        resultView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(AdaptIconSize(80))
        }

        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(resultView.snp.bottom).offset(AS(19))
            make.centerX.equalToSuperview()
            make.size.equalTo(titleLabel.size)
        }

        resultView.play()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clickEvent?()
    }
}
