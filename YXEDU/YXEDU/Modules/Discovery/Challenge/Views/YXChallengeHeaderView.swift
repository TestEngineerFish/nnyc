//
//  YXChallengeHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeHeaderView: UIView {

    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeBackgroundImage")
        return imageView
    }()

    var gameTitleLabel: UILabel = {
        let label = UILabel()
        label.text      = "本活动距离结束还有："
        label.textColor = UIColor.hex(0xE59000)
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return label
    }()

    var propertyView  = YXChallengePropertyView()

    var countDownView = YXCountDownView()

    var startButton   = YXChallengeStartButton()

    var previousRankButton: YXButton = {
        let button = YXButton()
        button.setTitle("查看上期排名", for: .normal)
        button.setTitleColor(UIColor.hex(0xD18714), for: .normal)
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return button
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        propertyView.bindData(100000)
        countDownView.bindData(368200)
        startButton.bindData(.again)
    }

    var gameRuleButton: YXButton = {
        let button = YXButton()
        button.setTitle("查看游戏规则", for: .normal)
        button.setTitleColor(UIColor.hex(0xD18714), for: .normal)
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        self.addSubview(backgroundImage)
        self.addSubview(gameTitleLabel)
        self.addSubview(propertyView)
        self.addSubview(countDownView)
        self.addSubview(startButton)
        self.addSubview(previousRankButton)
        self.addSubview(gameRuleButton)

        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        gameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(150))
            make.top.equalToSuperview().offset(AdaptSize(102))
            make.size.equalTo(CGSize(width: AdaptSize(121), height: AdaptSize(17)))
        }

        propertyView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(AdaptSize(25)))
            make.size.equalTo(CGSize(width: AdaptSize(44), height: AdaptSize(23)))
        }

        countDownView.snp.makeConstraints { (make) in
            make.left.equalTo(gameTitleLabel)
            make.top.equalTo(gameTitleLabel.snp.bottom).offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(170), height: AdaptSize(18)))
        }

        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(countDownView.snp.bottom).offset(AdaptSize(33))
            make.size.equalTo(CGSize(width: AdaptSize(230), height: AdaptSize(57)))
        }

        previousRankButton.snp.makeConstraints { (make) in
            make.left.equalTo(startButton).offset(AdaptSize(30))
            make.top.equalTo(startButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(73), height: AdaptSize(17)))
        }

        gameRuleButton.snp.makeConstraints { (make) in
            make.right.equalTo(startButton).offset(AdaptSize(-30))
            make.top.equalTo(startButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(73), height: AdaptSize(17)))
        }
    }

    // MARK: ==== Request ====



}
