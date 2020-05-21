//
//  YXReviewPlanCollectionViewItem.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXReviewPlanCollectionViewItem: UICollectionViewCell {

    var startListenPlanEvent: (()->Void)?
    var startReviewPlanEvent: (()->Void)?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
        label.textAlignment = .center
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.gray4
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var listenView: UIView = {
        let view = UIView()
        return view
    }()

    var reviewView: UIView = {
        let view = UIView()
        return view
    }()

    var listenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iPad_listenIcon")
        return imageView
    }()

    var reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iPad_reviewIcon")
        return imageView
    }()

    var listenButton: UIButton = {
        let button = UIButton()
        button.setTitle("开始听写", for: .normal)
        button.setTitleColor(UIColor.hex(0x13C600), for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(20))
        button.backgroundColor    = .clear
        button.layer.borderWidth  = AdaptSize(1)
        button.layer.borderColor  = UIColor.hex(0x4FDB40).cgColor
        button.layer.cornerRadius = AdaptSize(21)
        return button
    }()

    var reviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("开始学习", for: .normal)
        button.setTitleColor(UIColor.hex(0xFB7A19), for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(20))
        button.backgroundColor    = .clear
        button.layer.borderWidth  = AdaptSize(1)
        button.layer.borderColor  = UIColor.hex(0xFB7A19).cgColor
        button.layer.cornerRadius = AdaptSize(21)
        return button
    }()

    var listenStarView: YXStarView = {
        let view = YXStarView()
        view.isHidden = true
        return view
    }()

    var reviewStarView: YXStarView = {
        let view = YXStarView()
        view.isHidden = true
        return view
    }()

    var listenProgressView: YXReviewPlanProgressView = {
        let view = YXReviewPlanProgressView()
        view.isHidden = true
        return view
    }()

    var reviewProgressView: YXReviewPlanProgressView = {
        let view = YXReviewPlanProgressView()
        view.isHidden = true
        return view
    }()

    var listenScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.gray4
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    var reviewScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.gray4
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    let dotView: UIView = {
        let view = YXRedDotView()
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func createSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(listenView)
        contentView.addSubview(reviewView)
        contentView.addSubview(dotView)
        listenView.addSubview(listenImageView)
        listenView.addSubview(listenButton)
        listenView.addSubview(listenStarView)
        listenView.addSubview(listenProgressView)
        listenView.addSubview(listenScoreLabel)
        reviewView.addSubview(reviewImageView)
        reviewView.addSubview(reviewButton)
        reviewView.addSubview(reviewStarView)
        reviewView.addSubview(reviewProgressView)
        reviewView.addSubview(reviewScoreLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(70))
            make.right.equalToSuperview().offset(AdaptSize(-70))
            make.height.equalTo(AdaptSize(28))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(7))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(21))
        }
        listenView.size = CGSize(width: AdaptSize(183), height: AdaptSize(167))
        listenView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(21))
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        reviewView.size = CGSize(width: AdaptSize(183), height: AdaptSize(167))
        reviewView.snp.makeConstraints { (make) in
            make.left.equalTo(listenView.snp.right)
            make.bottom.right.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(21))
        }
        dotView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptIconSize(5), height: AdaptIconSize(5)))
            make.top.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
        }
        listenImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(67), height: AdaptSize(64)))
        }
        listenButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-14))
            make.size.equalTo(CGSize(width: AdaptSize(134), height: AdaptSize(42)))
        }
        listenStarView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(17))
            make.width.equalTo(AdaptSize(90))
            make.height.equalTo(AdaptSize(40))
        }
        listenProgressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(57), height: AdaptSize(57)))
        }
        listenScoreLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(listenProgressView.snp.bottom).offset(AdaptSize(9))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
        }
        reviewImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(67), height: AdaptSize(64)))
        }
        reviewButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-14))
            make.size.equalTo(CGSize(width: AdaptSize(134), height: AdaptSize(42)))
        }
        reviewStarView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(17))
            make.width.equalTo(AdaptSize(90))
            make.height.equalTo(AdaptSize(40))
        }
        reviewProgressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(57), height: AdaptSize(57)))
        }
        reviewScoreLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(listenProgressView.snp.bottom).offset(AdaptSize(9))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
        }
    }

    internal func bindProperty() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.setDefaultShadow()
        self.contentView.layer.cornerRadius = AdaptSize(20)
        self.listenView.clipRectCorner(direction: .bottomLeft, cornerRadius: AdaptSize(20))
        self.reviewView.clipRectCorner(direction: .bottomRight, cornerRadius: AdaptSize(20))
        self.listenView.layer.setGradient(colors: [UIColor.hex(0xFFFFFF), UIColor.hex(0xE8F6EA)], direction: .vertical)
        self.reviewView.layer.setGradient(colors: [UIColor.hex(0xFFFFFF), UIColor.hex(0xFFFAE2)], direction: .vertical)
        self.listenButton.addTarget(self, action: #selector(startListenEvent), for: .touchUpInside)
        self.reviewButton.addTarget(self, action: #selector(startReviewEvent), for: .touchUpInside)
    }

    func setData(_ model: YXReviewPlanModel) {
        self.dotView.isHidden      = model.shouldShowRedDot == .some(0)
        self.titleLabel.text       = model.planName
        self.descriptionLabel.text = "单词：\(model.wordCount)"
        self.listenProgressView.progress = CGFloat(model.listen)/100
        self.reviewProgressView.progress = CGFloat(model.review)/100
        self.listenStarView.showReviewPlanView(starNum: model.listen)
        self.reviewStarView.showReviewPlanView(starNum: model.review)

        switch model.listenState {
        case .normal:
            self.listenStarView.isHidden     = true
            self.listenProgressView.isHidden = true
            self.listenScoreLabel.isHidden   = true
            self.listenImageView.isHidden    = false
            self.listenButton.setTitle("开始听写", for: .normal)
        case .learning:
            self.listenStarView.isHidden     = true
            self.listenProgressView.isHidden = false
            self.listenScoreLabel.isHidden   = false
            self.listenImageView.isHidden    = true
            self.listenScoreLabel.text       = "听写进度"
            self.listenButton.setTitle("继续听写", for: .normal)
        case .finish:
            self.listenStarView.isHidden     = false
            self.listenProgressView.isHidden = true
            self.listenScoreLabel.isHidden   = false
            self.listenImageView.isHidden    = true
            self.listenScoreLabel.text       = "听写成绩"
            self.listenButton.setTitle("继续听写", for: .normal)
        }

        switch model.reviewState {
        case .normal:
            self.reviewStarView.isHidden     = true
            self.reviewProgressView.isHidden = true
            self.reviewScoreLabel.isHidden   = true
            self.reviewImageView.isHidden    = false
            self.reviewButton.setTitle("开始学习", for: .normal)
        case .learning:
            self.reviewStarView.isHidden     = true
            self.reviewProgressView.isHidden = false
            self.reviewScoreLabel.isHidden   = false
            self.reviewImageView.isHidden    = true
            self.reviewScoreLabel.text = "学习进度"
            self.reviewButton.setTitle("继续学习", for: .normal)
        case .finish:
            self.reviewStarView.isHidden     = false
            self.reviewProgressView.isHidden = true
            self.reviewScoreLabel.isHidden   = false
            self.reviewImageView.isHidden    = true
            self.reviewScoreLabel.text = "学习成绩"
            self.reviewButton.setTitle("继续学习", for: .normal)
        }

        if model.listenState == .normal && model.reviewState != .normal {
            self.listenImageView.layer.opacity = 0.24
        } else {
            self.listenImageView.layer.opacity = 1.0
        }
        if model.listenState != .normal && model.reviewState == .normal {
            self.reviewImageView.layer.opacity = 0.24
        } else {
            self.reviewImageView.layer.opacity = 1.0
        }
    }

    // MARK: ==== Event ====
    @objc internal func startListenEvent() {
        self.startListenPlanEvent?()
    }

    @objc internal func startReviewEvent() {
        self.startReviewPlanEvent?()
    }
}
