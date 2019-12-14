//
//  YXGameQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameQuestionView: UIView {
    var headerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestionHeader")
        return imageView
    }()

    var contentView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestionContent")
        return imageView
    }()

    var wordMeaningLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x9E653D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(26))
        label.textAlignment = .center
        return label
    }()

    var wordPhoneticSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x9E653D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(22))
        label.textAlignment = .center
        return label
    }()

    var bottomView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestionBottom")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(headerView)
        self.addSubview(contentView)
        self.addSubview(bottomView)
        contentView.addSubview(wordMeaningLabel)
        contentView.addSubview(wordPhoneticSymbolLabel)

        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(62))
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(34))
        }
        wordMeaningLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(9))
            make.height.equalTo(AdaptSize(39))
            make.left.right.equalToSuperview()
        }
        wordPhoneticSymbolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wordMeaningLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(30))
        }
    }

    func bindData(_ wordModel: YXGameWordModel) {
        self.wordMeaningLabel.text        = wordModel.meaning
        self.wordPhoneticSymbolLabel.text = wordModel.nature
    }
}
