//
//  YXGameHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameHeaderView: UIView {

    var backButton: UIButton = {
        let button = UIButton()
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
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(19.2))
        return label
    }()

    var recordLeftLabel: UILabel = {
        let label = UILabel()
        label.text          = "已答对"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()

    var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameQuestion-0")
        return imageView
    }()

    var recordRightLabel: UILabel = {
        let label = UILabel()
        label.text          = "题"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()

    var timer: Timer?
    var configModel: YXGameConfig?
    var consumeTime: Int = 0 //毫秒
    var lastQuestionTime = 0
    var currentQuestionNumber = 0
    weak var vcDelegate: YXGameViewControllerProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubviews()
    }

    deinit {
        self.stopTimer()
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
            make.left.equalToSuperview().offset(AdaptIconSize(16))
            make.top.equalToSuperview().offset(AdaptIconSize(25))
            make.size.equalTo(CGSize(width: AdaptIconSize(45.6), height: AdaptIconSize(30)))
        }
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptIconSize(3))
            make.left.equalToSuperview().offset(AdaptIconSize(9))
            make.size.equalTo(CGSize(width: AdaptIconSize(26.4), height: AdaptIconSize(22.4)))
        }

        timeBgView.snp.makeConstraints { (make) in
            make.left.equalTo(backBgView.snp.right).offset(AdaptSize(34))
            make.top.equalTo(backBgView)
            make.size.equalTo(CGSize(width: AdaptIconSize(134), height: AdaptIconSize(30)))
        }
        clockImageView.snp.makeConstraints { (make) in
            make.left.equalTo(timeBgView).offset(AdaptSize(6))
            make.bottom.equalTo(timeBgView)
            make.size.equalTo(CGSize(width: AdaptIconSize(40), height: AdaptIconSize(45.6)))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(clockImageView.snp.right).offset(AdaptSize(4))
            make.right.equalToSuperview()
        }

        recordBgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-16))
            make.top.equalTo(backBgView)
            make.width.equalTo(AdaptIconSize(84))
            make.height.equalTo(AdaptIconSize(30))
        }
        recordLeftLabel.sizeToFit()
        recordLeftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(6))
            make.width.equalTo(recordLeftLabel.width)
            make.top.bottom.equalToSuperview()
        }
        recordImageView.snp.makeConstraints { (make) in
            make.left.equalTo(recordLeftLabel.snp.right).offset(AdaptSize(3))
            make.bottom.equalToSuperview()
            make.width.equalTo(AdaptIconSize(20))
            make.height.equalTo(AdaptIconSize(23.2))
        }
        recordRightLabel.sizeToFit()
        recordRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recordImageView.snp.right).offset(AdaptIconSize(3))
            make.top.bottom.equalToSuperview()
            make.width.equalTo(recordRightLabel.width)
        }
    }

    func bindData(_ config: YXGameConfig) {
        self.configModel = config
        self.consumeTime = 0
        self.timeLabel.text = getCountDownText(config.totalTime)
    }

    // MARK: ==== Tools ====
    private func getBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = AdaptIconSize(15)
        view.layer.borderColor  = UIColor.hex(0xFFF2D4).cgColor
        view.layer.borderWidth  = AdaptIconSize(0.5)
        view.backgroundColor    = UIColor.hex(0xEA8D1A).withAlphaComponent(0.4)
        return view
    }

    private func getCountDownText(_ time: Int) -> String {
        let secondTime = time / 1000
        let hour   = secondTime / 3600
        let minute = (secondTime % 3600) / 60
        let second = secondTime % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    // MARK: ==== Event ====
    func addQuestionNumber() {
        currentQuestionNumber += 1
        // 记录最近一次答对的时间
        self.lastQuestionTime      = self.consumeTime
        self.recordImageView.image = UIImage(named: "gameQuestion-\(currentQuestionNumber)")
    }

    func getTimeAndQuestionNumber() -> (Int, Int) {
        var time     = 0
        var question = 0
        if let model = self.configModel {
            time     = self.lastQuestionTime > model.totalTime * 1000 ? model.totalTime * 1000 : self.lastQuestionTime
            question = self.currentQuestionNumber > model.totalQuestionNumber ? model.totalQuestionNumber : self.currentQuestionNumber
        } else {
            time     = self.lastQuestionTime
            question = self.currentQuestionNumber
        }
        YXLog("挑战总用时：\(time)，答对数“\(question)")
        return (time, question)
    }

    func startTimer() {
        self.stopTimer()
        guard let currentVC = YRRouter.sharedInstance().currentNavigationController()?.visibleViewController, currentVC.classForCoder == YXGameViewController.classForCoder() else {
            return
        }
        timer = Timer(fire: Date(), interval: 0.001, repeats: true, block: { [weakself = self] (timer) in
            guard let config = weakself.configModel else {
                return
            }
            weakself.consumeTime += 1
            var margin = config.totalTime * 1000 - weakself.consumeTime
            margin = margin < 0 ? 0 : margin
            weakself.timeLabel.text = self.getCountDownText(margin)
            if margin <= 0 {
                weakself.vcDelegate?.showResultView()
                timer.invalidate()
            }
        })
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

}
