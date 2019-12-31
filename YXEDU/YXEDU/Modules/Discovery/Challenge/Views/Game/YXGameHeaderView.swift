//
//  YXGameHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameHeaderView: UIView {

    var backButton: YXButton = {
        let button = YXButton()
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
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(19.2))
        return label
    }()

    var recordLeftLabel: UILabel = {
        let label = UILabel()
        label.text          = "已答对"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(11.2))
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
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(11.2))
        label.textAlignment = .center
        return label
    }()

    var timer: Timer?
    var configModel: YXGameConfig?
    var consumeTime: Int = 0 //毫秒
    var lastQuestionTime = 0
    var currentQuestionNumber = 0
    var vcDelegate: YXGameViewControllerProtocol?

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
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.size.equalTo(CGSize(width: AdaptSize(45.6), height: 30))
        }
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(3))
            make.left.equalToSuperview().offset(AdaptSize(9))
            make.size.equalTo(CGSize(width: AdaptSize(26.4), height: AdaptSize(22.4)))
        }

        timeBgView.snp.makeConstraints { (make) in
            make.left.equalTo(backBgView.snp.right).offset(AdaptSize(34))
            make.top.equalTo(backBgView)
            make.size.equalTo(CGSize(width: AdaptSize(134), height: 30))
        }
        clockImageView.snp.makeConstraints { (make) in
            make.left.equalTo(timeBgView).offset(AdaptSize(6))
            make.bottom.equalTo(timeBgView)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(45.6)))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(clockImageView.snp.right).offset(AdaptSize(4))
            make.right.equalToSuperview()
        }

        recordBgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-16))
            make.top.equalTo(backBgView)
            make.width.equalTo(AdaptSize(84))
            make.height.equalTo(AdaptSize(30))
        }
        recordLeftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(6))
            make.width.equalTo(AdaptSize(34))
            make.top.bottom.equalToSuperview()
        }
        recordImageView.snp.makeConstraints { (make) in
            make.left.equalTo(recordLeftLabel.snp.right).offset(AdaptSize(3))
            make.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(20))
            make.height.equalTo(AdaptSize(23.2))
        }
        recordRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recordImageView.snp.right).offset(AdaptSize(3))
            make.top.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(12))
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
        view.layer.cornerRadius = AdaptSize(15)
        view.layer.borderColor  = UIColor.hex(0xFFF2D4).cgColor
        view.layer.borderWidth  = AdaptSize(0.5)
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
        self.lastQuestionTime = self.currentQuestionNumber
        self.recordImageView.image = UIImage(named: "gameQuestion-\(currentQuestionNumber)")
    }

    func getTimeAndQuestionNumber() -> (Int, Int) {
        return (self.consumeTime, self.currentQuestionNumber)
    }

    func startTimer() {
        self.stopTimer()
        timer = Timer(fire: Date(), interval: 0.001, repeats: true, block: { (timer) in
            guard let config = self.configModel else {
                return
            }

            self.consumeTime += 1
            var margin = config.totalTime * 1000 - self.consumeTime
            margin = margin < 0 ? 0 : margin
            self.timeLabel.text = self.getCountDownText(margin)
            print("header \(margin)")
            if margin <= 0 {
                print("跳转")
                self.vcDelegate?.showResultView()
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
