//
//  YXCalendarCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/1.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXCalendarCellProtocol: NSObjectProtocol {
    func clickAction()
}

class YXCalendarCell: YXView {

    weak var delegate: YXCalendarCellProtocol?
    var model: YXCalendarStudyModel
    var isToday: Bool
    let isShowedAnimation = YXUserModel.default.isFirstStudy

    var smallPunchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "exercise_answer_right")
        imageView.isHidden = true
        return imageView
    }()
    var largePunchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        imageView.isHidden = true
        return imageView
    }()
    var smallDayLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()
    var largeDayLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    init(model: YXCalendarStudyModel, isToday: Bool, frame: CGRect) {
        self.model   = model
        self.isToday = isToday
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(smallPunchImageView)
        self.addSubview(largePunchImageView)
        self.addSubview(smallDayLabel)
        self.addSubview(largeDayLabel)
        smallPunchImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(15), height: AdaptSize(15)))
            make.centerX.equalToSuperview()
        }
        largePunchImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
            make.centerX.equalToSuperview()
        }
        smallDayLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize(-2))
            make.left.right.equalToSuperview()
        }
        largeDayLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.cornerRadius = AdaptSize(4)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.clickAction))
        self.addGestureRecognizer(tapAction)

        let date = Date(timeIntervalSince1970: Double(model.time ?? 0))
        let day  = (date as NSDate).day()
        self.smallDayLabel.text = isToday ? "今" : "\(day)"
        self.largeDayLabel.text = isToday ? "今" : "\(day)"

        if self.model.status == 0 {
            self.largeDayLabel.isHidden = false
        } else {
            self.smallDayLabel.isHidden = false
            if isToday && self.isShowedAnimation {
                self.largePunchImageView.isHidden = false
            } else {
                self.smallPunchImageView.isHidden = false
            }
        }

        if isToday && self.isShowedAnimation {
            self.backgroundColor = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
            self.smallDayLabel.textColor = .white
            self.largeDayLabel.textColor = .white
        } else {
            self.backgroundColor = UIColor.hex(0xFFF0DA)
        }

    }

    // MARK: ==== Event ====
    func showAnimation(duration: Double) {
        guard self.isShowedAnimation else { return }
        let animater            = CAKeyframeAnimation(keyPath: "transform.scale")
        animater.values         = [1.0, 0.1, 1.2, 1.0]// 先保持大小比例,再放大,最后恢复默认大小
        animater.duration       = duration
        animater.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(animater, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration/2) { [weak self] in
            guard let self = self else { return }
            self.smallPunchImageView.isHidden = false
            self.largePunchImageView.isHidden = true
            self.largeDayLabel.isHidden  = true
            self.smallDayLabel.isHidden  = false
            self.backgroundColor         = UIColor.hex(0xFFF0DA)
            self.smallDayLabel.textColor = .orange1
        }
    }

    @objc
    private func clickAction() {
        guard isToday, self.isShowedAnimation else {
            return
        }
        self.delegate?.clickAction()
    }
}
