//
//  YXNewLearnResultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnResultView: UIView {

    static let share = YXNewLearnResultView()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AdaptSize(6)
        return view
    }()

    var squirrelmageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var firstStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var secondStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var thirdStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()

    var goldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeGoldIcon")
        imageView.isHidden = true
        return imageView
    }()

    var bonusLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.orange1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ star: Int) {
        self.squirrelmageView.image = UIImage(named: "learnResult\(star)")
        firstStarImageView.image    = UIImage(named: "star_h_disable")
        secondStarImageView.image   = UIImage(named: "star_h_disable")
        thirdStarImageView.image    = UIImage(named: "star_h_disable")
        bonusLabel.text             = "+\(star)"
        titleLabel.text             = "Try again"
        bonusLabel.isHidden         = true
        goldImageView.isHidden      = true
        if star > 0 {
            firstStarImageView.image = UIImage(named: "star_h_enable")
        }
        if star > 1 {
            goldImageView.isHidden = false
            bonusLabel.isHidden    = false
            titleLabel.text        = "太棒啦"
            secondStarImageView.image = UIImage(named: "star_h_enable")
        }
        if star > 2 {
            thirdStarImageView.image = UIImage(named: "star_h_enable")
        }
        self.layoutSubviews()
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func hide() {
        self.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.snp.updateConstraints { (make) in
            make.size.equalTo(titleLabel.size)
        }
        self.bonusLabel.sizeToFit()
        self.bonusLabel.snp.updateConstraints { (make) in
            make.size.equalTo(bonusLabel.size)
        }
        if self.goldImageView.isHidden {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(211))
            }
        } else {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(226))
            }
        }
    }

    private func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(squirrelmageView)
        contentView.addSubview(firstStarImageView)
        contentView.addSubview(secondStarImageView)
        contentView.addSubview(thirdStarImageView)
        contentView.addSubview(goldImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bonusLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(AdaptSize(226))
            make.width.equalTo(AdaptSize(275))
        }
        squirrelmageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(38))
            make.size.equalTo(CGSize(width: AdaptSize(233), height: AdaptSize(109)))
        }
        firstStarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondStarImageView).offset(AdaptSize(2))
            make.right.equalTo(secondStarImageView.snp.left).offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
        }
        secondStarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(squirrelmageView).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        thirdStarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(secondStarImageView.snp.right).offset(AdaptSize(-6))
            make.centerY.equalTo(secondStarImageView).offset(AdaptSize(2))
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(squirrelmageView.snp.bottom).offset(AdaptSize(11))
            make.size.equalTo(CGSize.zero)
        }
        goldImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(116))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        bonusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goldImageView.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(goldImageView)
            make.size.equalTo(CGSize.zero)
        }
    }
}
