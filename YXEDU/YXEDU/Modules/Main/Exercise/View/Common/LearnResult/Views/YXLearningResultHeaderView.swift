//
//  YXLearningResultHeaderView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YXLearningResultHeaderView: UIView {

    var model: YXLearnMapUnitModel
    var newLearnAmount: Int = 0
    var reviewLearnAmount: Int = 0

    var firstStar  = UIImageView()
    var secondStar = UIImageView()
    var thirdStar  = UIImageView()

    init(_ model:YXLearnMapUnitModel, newAmount: Int, reviewAmount: Int) {
        self.model     = model
        self.newLearnAmount = newAmount
        self.reviewLearnAmount = reviewAmount
        super.init(frame: CGRect.zero)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {

        // 松鼠头像
        let imageView = UIImageView()
        imageView.image = UIImage(named: "learnResult\(model.stars)")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(AdaptSize(223))
            make.height.equalTo(AdaptSize(109))
        }
        // 星星
        firstStar.image  = model.stars > 0 ? UIImage(named: "star_enable") : UIImage(named: "star_disable")
        secondStar.image = model.stars > 1 ? UIImage(named: "star_enable") : UIImage(named: "star_disable")
        thirdStar.image  = model.stars > 2 ? UIImage(named: "star_enable") : UIImage(named: "star_disable")
        firstStar.isHidden  = true
        secondStar.isHidden = true
        thirdStar.isHidden  = true
        self.addSubview(firstStar)
        self.addSubview(secondStar)
        self.addSubview(thirdStar)
        secondStar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView)
            make.width.height.equalTo(35)
        }
        firstStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondStar)
            make.right.equalTo(secondStar.snp.left)
            make.width.height.equalTo(27)
        }
        thirdStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondStar)
            make.left.equalTo(secondStar.snp.right)
            make.height.width.equalTo(27)
        }

        // 单元标题
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        let titleText = "恭喜完成 " + (model.unitName ?? "") + " 的学习!"
        let titleMutAttrStr = NSMutableAttributedString(string: titleText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x323232), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 17)])
        titleMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 17)], range: NSRange(location: 5, length: titleText.count - 5))
        titleLabel.attributedText = titleMutAttrStr

        // 进度标题
        let progressLabel = UILabel()
        progressLabel.textAlignment = .center
        let percent = "\(model.rate * 100)%"
        let progressText = "\(model.unitName ?? "") 完成 " + percent
        let progressMutAttrStr = NSMutableAttributedString(string: progressText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x323232), NSAttributedString.Key.font:UIFont.mediumFont(ofSize: AdaptSize(17))])
        progressMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.regularFont(ofSize: AdaptSize(17))], range: NSRange(location: progressText.count - percent.count - 2, length: 2))
        progressMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.semiboldFont(ofSize: AdaptSize(17)), NSAttributedString.Key.foregroundColor:UIColor.orange1], range: NSRange(location: progressText.count - percent.count, length: percent.count))
        progressLabel.attributedText = progressMutAttrStr

        // 进度条
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.orange1
        progressView.trackTintColor = UIColor.hex(0xEFECE2)
        progressView.setProgress(self.model.rate, animated: true)

        // 新学标题
        let newLearnLabel = UILabel()
        newLearnLabel.textAlignment = .left
        let newLearnText = "• 新掌握了 \(newLearnAmount) 个单词"
        let newLearnMutAttrStr = NSMutableAttributedString(string: newLearnText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
        newLearnMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 7, length: newLearnText.count - 11))
        newLearnLabel.attributedText = newLearnMutAttrStr

        // 巩固标题
        let reviewLabel = UILabel()
        reviewLabel.textAlignment = .left
        let reviewText = "• 巩固了 \(reviewLearnAmount) 个单词"
        let reViewMutAttrStr = NSMutableAttributedString(string: reviewText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
        reViewMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 6, length: reviewText.count - 10))
        reviewLabel.attributedText = reViewMutAttrStr

        self.addSubview(titleLabel)
        self.addSubview(progressLabel)
        self.addSubview(progressView)
        self.addSubview(newLearnLabel)
        self.addSubview(reviewLabel)

        // 新学文本Y值
        var offsetY = CGFloat.zero
        if model.status == .uniteEnd {
            progressLabel.isHidden = true
            progressView.isHidden  = true
            offsetY = AdaptSize(45)
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(11))
                make.height.equalTo(AdaptSize(24))
                make.width.equalToSuperview()
            }
            self.showAnimation()
        } else {
            titleLabel.isHidden = true
            offsetY = AdaptSize(63)
            progressLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(11))
                make.height.equalTo(AdaptSize(24))
                make.width.equalToSuperview()
            }
            progressView.snp.makeConstraints { (make) in
                make.top.equalTo(progressLabel.snp.bottom).offset(AdaptSize(7))
                make.centerX.equalToSuperview()
                make.width.equalTo(AdaptSize(160))
                make.height.equalTo(AdaptSize(8))
            }
            progressView.layer.cornerRadius  = AdaptSize(8/2)
            progressView.layer.masksToBounds = true
        }

        newLearnLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(offsetY)
            make.left.equalTo(self.snp.centerX).offset(AdaptSize(-60))
            make.width.equalTo(AdaptSize(200))
            make.height.equalTo(AdaptSize(20))
        }

        reviewLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(newLearnLabel)
            make.top.equalTo(newLearnLabel.snp.bottom).offset(2)
        }

        // 如果有扩展单元解锁
        if let _unlockUnit = model.ext {
            let unlockLabel = UILabel()
            unlockLabel.textAlignment = .left
            let unlockText = "• 解锁了 " + _unlockUnit.unitName
            let unlockMutAttrStr = NSMutableAttributedString(string: unlockText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
            unlockMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 6, length: unlockText.count - 6))
            unlockLabel.attributedText = unlockMutAttrStr
            self.addSubview(unlockLabel)
            unlockLabel.snp.makeConstraints { (make) in
                make.left.height.width.equalTo(newLearnLabel)
                make.top.equalTo(reviewLabel.snp.bottom).offset(2)
            }
        }

    }

    private func showAnimation() {
        let duration = Double(0.75)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.0, 1.2, 1.0]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*1) {
            self.firstStar.isHidden = false
            self.firstStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*2) {
            self.secondStar.isHidden = false
            self.secondStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*3) {
            self.thirdStar.isHidden = false
            self.thirdStar.layer.add(animation, forKey: nil)
        }
    }



}


