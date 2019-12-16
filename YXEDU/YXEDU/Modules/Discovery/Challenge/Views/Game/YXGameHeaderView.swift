//
//  YXGameHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameHeaderView: UIView {

    var backButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "gameBack"), for: .normal)
        return button
    }()

    var clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameClock")
        return imageView
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor     = UIColor.white
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(19.2))
        return label
    }()

    var recordLeftLabel: UILabel = {
        let label = UILabel()
        label.text          = "已答对"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(11.2))
        label.textAlignment = .center
        return label
    }()

    var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestion-1")
        return imageView
    }()

    var recordRightLabel: UILabel = {
        let label = UILabel()
        label.text          = "题"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(11.2))
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        let backBgView   = self.getBackgroundView()
        let timeBgView   = self.getBackgroundView()
        let recordBgView = self.getBackgroundView()
        self.addSubview(backBgView)
        self.addSubview(timeBgView)
        self.addSubview(recordBgView)
        self.addSubview(clockImageView)
        backBgView.addSubview(backButton)
        timeBgView.addSubview(timeLabel)
        recordBgView.addSubview(recordLeftLabel)
        recordBgView.addSubview(recordImageView)
        recordBgView.addSubview(recordRightLabel)

        backBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.size.equalTo(CGSize(width: AdaptSize(45.6), height: 30))
        }
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(3))
            make.left.equalToSuperview().offset(AdaptSize(9))
            make.size.equalTo(CGSize(width: AdaptSize(26.4), height: AdaptSize(22.4)))
        }

        timeBgView.snp.makeConstraints { (make) in
            make.left.equalTo(backBgView.snp.right).offset(AdaptSize(34))
            make.top.equalTo(backBgView)
            make.size.equalTo(CGSize(width: AdaptSize(134), height: 30))
        }
        clockImageView.snp.makeConstraints { (make) in
            make.left.equalTo(timeBgView).offset(AdaptSize(6))
            make.bottom.equalTo(timeBgView)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(45.6)))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(clockImageView.snp.right).offset(AdaptSize(4))
            make.right.equalToSuperview()
        }

        recordBgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-16))
            make.top.equalTo(backBgView)
            make.width.equalTo(AdaptSize(84))
            make.height.equalTo(AdaptSize(30))
        }
        recordLeftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(6))
            make.width.equalTo(AdaptSize(34))
            make.top.bottom.equalToSuperview()
        }
        recordImageView.snp.makeConstraints { (make) in
            make.left.equalTo(recordLeftLabel.snp.right).offset(AdaptSize(3))
            make.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(20))
            make.height.equalTo(AdaptSize(23.2))
        }
        recordRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recordImageView.snp.right).offset(AdaptSize(3))
            make.top.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(12))
        }
    }

    func bindData(_ config: YXGameConfig) {
        self.timeLabel.text = getCountDownText(config.totalTime)
    }

    // MARK: ==== Tools ====
    private func getBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = AdaptSize(15)
        view.layer.borderColor  = UIColor.hex(0xFFF2D4).cgColor
        view.layer.borderWidth  = AdaptSize(0.5)
        view.backgroundColor    = UIColor.hex(0xEA8D1A).withAlphaComponent(0.4)
        return view
    }

    private func getCountDownText(_ time: Int) -> String {
        let hour   = time / 3600
        let minute = (time % 3600) / 60
        let second = time % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}