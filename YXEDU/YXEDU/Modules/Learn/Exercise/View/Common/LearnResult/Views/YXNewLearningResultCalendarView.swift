//
//  YXNewLearningResultCalendarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultCalendarView: YXView, FSCalendarDataSource, FSCalendarDelegate {

    var selectedDate = Date()

    var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_left_gray"), for: .normal)
        return button
    }()
    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_right_gray"), for: .normal)
        return button
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .center
        return label
    }()
    var calendarView: FSCalendar = {
        let weekValue = ["日", "一", "二", "三", "四", "五", "六", ]
        let calendar = FSCalendar()
        calendar.headerHeight    = .zero
        calendar.weekdayHeight   = AdaptSize(32)
        calendar.locale          = Locale(identifier: "zh-CN")
        calendar.scrollDirection = .horizontal
        calendar.appearance.titleDefaultColor     = UIColor.gray1
        calendar.appearance.titlePlaceholderColor = UIColor.black4
        calendar.appearance.weekdayFont      = UIFont.regularFont(ofSize: AdaptSize(13))
        calendar.appearance.weekdayTextColor = UIColor.gray1
        calendar.calendarWeekdayView.backgroundColor    = UIColor.hex(0xF4F4F4)
        calendar.calendarWeekdayView.layer.cornerRadius = AdaptSize(2)
        for (index, label) in calendar.calendarWeekdayView.weekdayLabels.enumerated() {
            if index < weekValue.count {
                label.text = weekValue[index]
            }
        }
        return calendar
    }()

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
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(titleLabel)
        self.addSubview(calendarView)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(20)))
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(20)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(leftButton.snp.right)
            make.right.equalTo(rightButton.snp.left)
        }
        calendarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptFontSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(288))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.calendarView.delegate   = self
        self.leftButton.addTarget(self, action: #selector(self.previousMonth), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(self.nextMonth), for: .touchUpInside)
        self.calendarView.register(YXCustomCalendarCell.classForCoder(), forCellReuseIdentifier: "kYXCustomCalendarCell")
    }

    // MARK: ==== Event ====

    @objc
    private func previousMonth() {
        self.selectedDate = NSDate.offsetMonths(-1, from: self.selectedDate)
        self.calendarView.setCurrentPage(self.selectedDate, animated: true)
    }

    @objc
    private func nextMonth() {
        self.selectedDate = NSDate.offsetMonths(1, from: self.selectedDate)
        self.calendarView.setCurrentPage(self.selectedDate, animated: true)
    }

    func setData() {
        self.titleLabel.text = "2020年6月"
    }

    // MARK: ==== FSCalendarDelegate ====
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let view: UIView = {
//            let view = UIView()
//            view.backgroundColor = UIColor.orange1
//            return view
//        }()
//        calendar.addSubview(view)
//        view.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
}
