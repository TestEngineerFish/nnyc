//
//  YXGameQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameQuestionView: UIView, CAAnimationDelegate {
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

    var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestionContent")
        return imageView
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    var wordMeaningLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x9E653D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(20))
        label.textAlignment = .center
        return label
    }()

    var wordPhoneticSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x9E653D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(18))
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
    var consumeTime = Int.zero
    var wordModel: YXGameWordModel?
    var timeout = Int.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.skipButton.addTarget(self, action: #selector(skipQuestion), for: .touchUpInside)
    }

    deinit {
        self.stopTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(containerView)
        self.containerView.addSubview(contentImageView)
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
        contentImageView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
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

    private func resetData() {
        self.skipButton.isHidden = true
        consumeTime = .zero
    }

    func bindData(_ wordModel: YXGameWordModel, timeout: Int) {
        self.wordModel = wordModel
        self.timeout   = timeout
        self.switchAnimation()
        self.resetData()
        self.startTimer()
    }

    // MARK: ==== Event ====
    @objc private func skipQuestion(_ button: UIButton) {
        self.vcDelegate?.skipQuestion()
        button.isHidden  = true
        self.consumeTime = 0
    }

    private func switchAnimation() {
        let duration: Double = 0.375
        let sinkageAnimation = CABasicAnimation(keyPath: "position.y")
        sinkageAnimation.duration       = duration
        sinkageAnimation.toValue        = self.height/2 - self.headerView.height
        sinkageAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        sinkageAnimation.repeatCount    = 1
        sinkageAnimation.autoreverses   = true
        sinkageAnimation.delegate       = self 
        self.headerView.layer.add(sinkageAnimation, forKey: nil)

        let flotAnimation = CABasicAnimation(keyPath: "position.y")
        flotAnimation.duration       = duration
        flotAnimation.toValue        = self.height/2
        flotAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flotAnimation.repeatCount    = 1
        flotAnimation.autoreverses   = true
        self.bottomView.layer.add(flotAnimation, forKey: nil)

        let foldAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        foldAnimation.toValue        = 0.7
        foldAnimation.duration       = duration
        foldAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        foldAnimation.repeatCount    = 1
        foldAnimation.autoreverses   = true
        self.contentImageView.layer.add(foldAnimation, forKey: nil)

        self.contentView.layer.scalingAnimation(duration)
    }

    // 重新开始计时
    func restartTimer() {
        self.skipButton.isHidden = true
        self.consumeTime = 0
        self.startTimer()
    }

    func startTimer() {
        self.stopTimer()
        timer = Timer(fire: Date(), interval: 1.0, repeats: true, block: { [weakSelf = self] (timer) in
            weakSelf.consumeTime += 1
            if weakSelf.consumeTime >= self.timeout {
                weakSelf.skipButton.isHidden = false
                weakSelf.timer?.invalidate()
            }
        })
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: ==== CAAnimationDelegate ====

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            guard let wordModel = self.wordModel else {
                return
            }
            self.wordMeaningLabel.text        = wordModel.meaning
            self.wordPhoneticSymbolLabel.text = wordModel.nature
        }
    }
}
