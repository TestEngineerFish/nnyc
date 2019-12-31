//
//  YXChallengeRankTopView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeRankTop3View: UIView {

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeTop3Bg")
        imageView.isHidden = true
        return imageView
    }()

    var titleView: UIButton = {
        let button = UIButton()
        button.setTitle("排行榜", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.titleLabel?.font   = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        button.isEnabled          = false
        button.backgroundColor    = UIColor.hex(0xF8F6F0)
        button.layer.borderColor  = UIColor.hex(0xFFD38E).cgColor
        button.layer.borderWidth  = 2
        button.layer.cornerRadius = AdaptSize(14)
        return button
    }()

    var firstView: YXChallengeRankTopView = {
        let view = YXChallengeRankTopView(.first)
        view.isHidden = true
        return view
    }()

    var secondView: YXChallengeRankTopView = {
        let view = YXChallengeRankTopView(.second)
        view.isHidden = true
        return view
    }()

    var thirdView: YXChallengeRankTopView = {
        let view = YXChallengeRankTopView(.third)
        view.isHidden = true
        return view
    }()

    var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeEmptyResult")
        imageView.isHidden = true
        return imageView
    }()

    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text          = "你是第一个前来挑战的呢！快来试试吧"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.hex(0xF4EEE2)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ rankedList: [YXChallengeUserModel]) {
        if rankedList.isEmpty {
            self.emptyImageView.isHidden = false
            self.emptyLabel.isHidden     = false
        } else {
            self.emptyImageView.isHidden = true
            self.emptyLabel.isHidden     = true
            self.firstView.isHidden  = false
            self.secondView.isHidden = false
            self.thirdView.isHidden  = false
            self.backgroundImageView.isHidden = false
            if rankedList.count > 0 {
                self.firstView.bindData(rankedList[0])
            }
            if rankedList.count > 1 {
                self.secondView.bindData(rankedList[1])
            }
            if rankedList.count > 2 {
                self.thirdView.bindData(rankedList[2])
            }
        }
    }

    private func setSubviews() {
        self.addSubview(backgroundImageView)
        self.addSubview(emptyImageView)
        self.addSubview(emptyLabel)
        self.addSubview(titleView)
        self.addSubview(firstView)
        self.addSubview(secondView)
        self.addSubview(thirdView)

        backgroundImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(titleView)
        }

        titleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(-4))
            make.top.equalToSuperview().offset(AdaptSize(-11))
            make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(28)))
        }

        emptyImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(222), height: AdaptSize(176)))
            make.top.equalToSuperview().offset(AdaptSize(49))
            make.centerX.equalToSuperview()
        }

        emptyLabel.sizeToFit()
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(emptyLabel.size)
            make.top.equalTo(emptyImageView.snp.bottom).offset(AdaptSize(11))
        }

        firstView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(11))
            make.width.equalTo(AdaptSize(116))
            make.bottom.equalToSuperview().offset(AdaptSize(-17))
        }

        secondView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(37))
            make.width.equalTo(AdaptSize(116))
            make.bottom.equalToSuperview().offset(AdaptSize(-17))
        }

        thirdView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.width.equalTo(secondView)
        }
    }
    
    
}
