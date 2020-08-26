//
//  YXNewLearningResultHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultHeaderView: YXView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let starView = YXStarView()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let progressView = YXProgressView(cornerRadius: AdaptSize(4), animation: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        self.addSubview(starView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(progressView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(-18))
            make.size.equalTo(CGSize(width: AdaptIconSize(233), height: AdaptIconSize(141)))
        }
        starView.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView)
            make.width.equalTo(AdaptIconSize(94))
            make.height.equalTo(AdaptIconSize(45))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptFontSize(-20))
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(11))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(2))
        }
        progressView.size = CGSize(width: AdaptSize(233), height: AdaptSize(8))
        progressView.snp.makeConstraints { (make) in
            make.size.equalTo(progressView.size)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(10))
            make.centerX.equalToSuperview()
        }
    }

    // MARK: ==== Event ====
    func setData() {
        self.imageView.image = UIImage(named: "review_result_base_\(3)star")
        self.starView.showLearnResultView(starNum: 3)
        self.titleLabel.text = "恭喜完成 Unit 2 的学习！"
        self.descriptionLabel.text = "您可以进入下一个单元进行学习哦！"
        self.progressView.isHidden = true
    }
}
