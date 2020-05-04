//
//  YXGameLaunchView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameLaunchView: UIView {

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameLaunch")
        return imageView
    }()

    var countDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameCountDown-3")
        imageView.contentMode = .center
        return imageView
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCSemiboldFont(withSize: AdaptFontSize(16))
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    var currentTimer: Int = 4
    weak var delegate: YXGameViewControllerProtocol?

    init(_ time: Int) {
        super.init(frame: CGRect.zero)
        self.setSubviews(time)
        self.showAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews(_ time: Int) {
        let minute = Int(time) / 60
        self.descriptionLabel.text = "在\(minute)分钟内\n试着连对更多单词吧"

        self.addSubview(backgroundView)
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubview(countDownImageView)
        backgroundImageView.addSubview(descriptionLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(AdaptSize(-20))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(328), height: AdaptSize(340)))
        }
        self.descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(descriptionLabel.width)
            make.height.equalTo(AdaptSize(45))
            make.bottom.equalToSuperview().offset(AdaptSize(-153))
        }
        countDownImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(AdaptSize(-21))
            make.size.equalTo(CGSize(width: AdaptSize(41), height: AdaptSize(47)))
        }
    }

    private func showAnimation() {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown(_:)), userInfo: nil, repeats: true)
        timer.fire()

    }

    @objc private func countDown(_ timer: Timer) {
        self.currentTimer -= 1
        if currentTimer == 0 {
            self.countDownImageView.image = UIImage(named: "gameCountDown-go")
        } else if currentTimer > 0 {
            self.countDownImageView.layer.scalingAnimation(1.0)
            self.countDownImageView.image = UIImage(named: "gameCountDown-\(self.currentTimer)")
        } else {
            self.delegate?.startGame()
            timer.invalidate()
            self.removeFromSuperview()
        }
    }
}
