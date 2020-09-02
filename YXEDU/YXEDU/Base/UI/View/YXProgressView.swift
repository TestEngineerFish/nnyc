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
    var showAnimation: Bool  = true
    var progressView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        self.addSubview(progressView)
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.cornerRadius              = self.height / 2
        self.progressView.layer.cornerRadius = self.height / 2
    }

    override func bindData() {
        super.bindData()
        self.bindProperty()
        if showAnimation {
            self.progressView.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: self.height))
            UIView.animate(withDuration: 0.6) { [weak self] in
                guard let self = self else { return }
                self.progressView.width = self.progress * self.width
            }
        } else {
            self.progressView.frame = CGRect(origin: .zero, size: CGSize(width: self.progress * self.width, height: self.height))
        }
    }
}
