//
//  YXProgressView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXProgressView: YXView {

    public var progress: CGFloat = 0 {
        didSet { self.bindData() }
    }
    private var showAnimation: Bool
    private var progressView = UIView()
    private var cornerRadius: CGFloat

    init(cornerRadius: CGFloat = AdaptSize(5), animation: Bool = false) {
        self.cornerRadius  = cornerRadius
        self.showAnimation = animation
        super.init(frame: CGRect.zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        self.addSubview(progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.left.top.height.equalToSuperview()
            make.width.equalTo(0)
        }
    }

    override func bindProperty() {
        self.backgroundColor     = UIColor.gray2
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = cornerRadius

        self.progressView.layer.masksToBounds = true
        self.progressView.layer.cornerRadius  = cornerRadius
        self.progressView.backgroundColor     = .orange1
    }

    override func bindData() {
        super.bindData()
        if showAnimation {
            UIView.animate(withDuration: 0.6) {[weak self] in
                guard let self = self else { return }
                self.progressView.width = self.progress * self.width
            }
        } else {
            self.progressView.width = self.progress * self.width
        }
    }
}
