//
//  YXCustomCalendarCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import FSCalendar

@objc
class YXCustomCalendarCell: FSCalendarCell {

    var dayLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .center
        return label
    }()
    var markDayLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()
    var markImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.removeAllSubviews()
        self.createSubviews()
        self.bindProperty()
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(dayLabel)
        self.addSubview(markDayLabel)
        self.addSubview(markImageView)
        dayLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        markDayLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-2))
        }
        markImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
    }

    private func bindProperty() {

    }

    // MARK: ==== Event ====
    func setData(date: Date, isPunch: Bool, isLearned: Bool) {
        self.dayLabel.text = "\((date as NSDate).day())"
        let currentMonth = (self.calendar.currentPage as NSDate).month()
        if (date as NSDate).month() == currentMonth {
            self.dayLabel.textColor = UIColor.gray1
        } else {
            self.dayLabel.textColor = UIColor.black4
        }
    }
}

