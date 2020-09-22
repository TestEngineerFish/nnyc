//
//  YXFeedbackTipsView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXFeedbackTipsView: YXView {

    var timer: Timer?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius  = AdaptSize(6)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var feedbackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "feedbackIcon_white"), for: .normal)
        button.setTitle("反馈问题", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()

    init(image: UIImage?) {
        super.init(frame: .zero)
        self.imageView.image = image
        self.createSubviews()
        self.bindProperty()
    }

    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        self.addSubview(feedbackButton)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.centerX.equalToSuperview()
            make.width.equalTo(AdaptSize(100))
            make.height.equalTo(AdaptSize(120))
        }
        feedbackButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(8))
            make.bottom.equalToSuperview().offset(AdaptSize(-8))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.isHidden = true
        self.backgroundColor    = UIColor.hex(0x111111)
        self.layer.cornerRadius = AdaptSize(8)
        self.feedbackButton.addTarget(self, action: #selector(self.toFeedbackVC), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc
    private func toFeedbackVC() {
        guard let image = self.imageView.image else {
            YXLog("截屏错误，图片无显示")
            YXUtils.showHUD(nil, title: "截图错误，请重试")
            self.hide()
            return
        }
        let vc = YXPersonalFeedBackVC()
        vc.screenShotImage = image
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
        self.hide()
    }

    func show() {
        self.isHidden = false
        kWindow.addSubview(self)
        self.size = CGSize(width: AdaptSize(110), height: AdaptSize(163))
        self.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(self.width)
            make.size.equalTo(self.size)
        }
        UIView.animate(withDuration: 0.6, animations: {
            [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(translationX: -self.width - AdaptSize(20), y: 0)
        }) { (finished) in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                    self?.hide()
                }
            }
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = .identity
        }) { (finished) in
            if finished {
                self.timer?.invalidate()
                self.timer = nil
                self.removeFromSuperview()
            }
        }
    }
}
