//
//  YXCountDownView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXCountDownView: UIView {

    func bindData(_ time: Int) {
        self.setCountDownView(time)
    }

    /// 设置倒计时视图
    /// - Parameter time: 单位秒
    private func setCountDownView(_ time: Int) {
        let day = 3600 * 24
        let dayNumber = time / day
        let hourNumber  = (time % day) / 3600
        let minuteNumber = (time % 3600) / 60

        var dayLeft  = "0"
        var dayRight = "\(dayNumber)"
        if dayNumber > 10 {
            dayLeft  = "\(dayNumber/10)"
            dayRight = "\(dayNumber % 10)"
        }
        var hourLeft = "0"
        var hourRight = "\(hourNumber)"
        if hourNumber > 10 {
            hourLeft  = "\(hourNumber/10)"
            hourRight = "\(hourNumber % 10)"
        }
        var minuteLeft  = "0"
        var minuteRight = "\(minuteNumber)"
        if minuteNumber > 10 {
            minuteLeft  = "\(minuteNumber/10)"
            minuteRight = "\(minuteNumber % 10)"
        }
        let dayLeftView     = self.getCountDownTimeView(dayLeft)
        let dayRightView    = self.getCountDownTimeView(dayRight)
        let dayLabel        = self.getLabel("天")
        let hourLeftView    = self.getCountDownTimeView(hourLeft)
        let hourRightView   = self.getCountDownTimeView(hourRight)
        let hourLabel       = self.getLabel("小时")
        let minuteLeftView  = self.getCountDownTimeView(minuteLeft)
        let minuteRightView = self.getCountDownTimeView(minuteRight)
        let minuteLabel     = self.getLabel("分钟")

        self.addSubview(dayLeftView)
        self.addSubview(dayRightView)
        self.addSubview(dayLabel)
        self.addSubview(hourLeftView)
        self.addSubview(hourRightView)
        self.addSubview(hourLabel)
        self.addSubview(minuteLeftView)
        self.addSubview(minuteRightView)
        self.addSubview(minuteLabel)

        let timeSize = CGSize(width: AdaptSize(13), height: AdaptSize(18))
        dayLeftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        dayRightView.snp.makeConstraints { (make) in
            make.left.equalTo(dayLeftView.snp.right).offset(AdaptSize(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        dayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dayRightView.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        hourLeftView.snp.makeConstraints { (make) in
            make.left.equalTo(dayLabel.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        hourRightView.snp.makeConstraints { (make) in
            make.left.equalTo(hourLeftView.snp.right).offset(AdaptSize(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        hourLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hourRightView.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: timeSize.width * 2, height: timeSize.height))
        }
        minuteLeftView.snp.makeConstraints { (make) in
            make.left.equalTo(hourLabel.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        minuteRightView.snp.makeConstraints { (make) in
            make.left.equalTo(minuteLeftView.snp.right).offset(AdaptSize(4))
            make.centerY.equalToSuperview()
            make.size.equalTo(timeSize)
        }
        minuteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(minuteRightView.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: timeSize.width * 2, height: timeSize.height))
        }
    }

    // MARK: ==== Tools ====
    private func getCountDownTimeView(_ text: String) -> UIView {
        let imageView = UIImageView()
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text          = text
            label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(13.2))
            label.textColor     = UIColor.white
            label.textAlignment = .center
            return label
        }()
        imageView.image = UIImage(named: "countDownBackground")
        imageView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return imageView
    }

    private func getLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text          = text
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textColor     = UIColor.hex(0xE59000)
        label.textAlignment = .center
        return label
    }
}
