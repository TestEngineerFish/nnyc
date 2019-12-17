//
//  YXGameQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameQuestionView: UIView {
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var skipButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "gameButtonSkip"), for: .normal)
        button.isHidden = true
        return button
    }()

    weak var vcDelegate: YXGameViewControllerProtocol?
    var timer: Timer?
    var consumeTime = Double.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.skipButton.addTarget(self, action: #selector(skipQuestion), for: .touchUpInside)
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(containerView)
        self.containerView.addSubview(contentView)
        self.containerView.addSubview(headerView)
        self.containerView.addSubview(bottomView)
        contentView.addSubview(wordMeaningLabel)
        contentView.addSubview(wordPhoneticSymbolLabel)
        bottomView.addSubview(skipButton)

        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(256), height: AdaptSize(183)))
        }
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
        skipButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-13))
            make.bottom.equalToSuperview().offset(AdaptSize(7))
            make.size.equalTo(CGSize(width: AdaptSize(70), height: AdaptSize(48)))
        }
    }

    func bindData(_ wordModel: YXGameWordModel, timeOut: Double) {
        self.wordMeaningLabel.text        = wordModel.meaning
        self.wordPhoneticSymbolLabel.text = wordModel.nature
        timer?.invalidate()
        timer = nil
        timer = Timer(fire: Date(), interval: 1.0, repeats: true, block: { [weak self] (timer) in
            guard let self = self else {
                return
            }
            self.consumeTime += 1
            print(self.consumeTime)
            if self.consumeTime >= timeOut {
                self.skipButton.isHidden = false
                self.timer?.invalidate()
            }
        })
        RunLoop.current.add(timer!, forMode: .common)
    }

    // MARK: ==== Event ====
    @objc private func skipQuestion(_ button: UIButton) {
        self.switchAnimation()
        self.vcDelegate?.skipQuestion()
        button.isHidden  = true
        self.consumeTime = 0
    }

    private func switchAnimation() {
        let sinkageAnimation = CABasicAnimation(keyPath: "position.y")
        sinkageAnimation.duration = 0.25
        sinkageAnimation.toValue = self.height/2 - self.headerView.height + AdaptSize(10)
        sinkageAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        sinkageAnimation.repeatCount = 1
        sinkageAnimation.autoreverses = true
        self.headerView.layer.add(sinkageAnimation, forKey: nil)

        let flotAnimation = CABasicAnimation(keyPath: "position.y")
        flotAnimation.duration = 0.25
        flotAnimation.toValue = self.height/2
        flotAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flotAnimation.repeatCount = 1
        flotAnimation.autoreverses = true
        self.bottomView.layer.add(flotAnimation, forKey: nil)

//        let foldAnimation = CABasicAnimation(keyPath: "bounds.height")
//        foldAnimation.toValue = CGFloat.zero
//        foldAnimation.duration = 0.5
//        foldAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        foldAnimation.repeatCount = 1
//        foldAnimation.autoreverses = true
//        self.contentView.layer.add(foldAnimation, forKey: nil)
    }
}
