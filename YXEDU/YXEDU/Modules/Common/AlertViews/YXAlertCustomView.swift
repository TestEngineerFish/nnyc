//
//  YXAlertCustomView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXAlertCustomView: UIView {

    static let share = YXAlertCustomView()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.cornerRadius  = AdaptSize(14)
        view.layer.masksToBounds = true
        return view
    }()

    var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alertCloseIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        self.addSubview(closeImageView)
        self.contentView.addSubview(indicatorView)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(-40))
            make.size.equalTo(CGSize(width: AdaptSize(331), height: AdaptSize(367)))
        }
        closeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(AdaptSize(14))
            make.size.equalTo(CGSize(width: AdaptSize(34), height: AdaptSize(34)))
        }
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(34), height: AdaptSize(34)))
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.closeImageView.addGestureRecognizer(tap)
    }

    func show(_ subview: UIView) {
        self.contentView.addSubview(subview)
        kWindow.addSubview(self)
        subview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    @objc private func hide() {
        self.removeFromSuperview()
    }
}
