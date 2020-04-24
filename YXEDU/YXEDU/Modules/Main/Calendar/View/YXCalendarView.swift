//
//  YXCalendarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/24.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXCalendarView: YXTopWindowView, FSCalendarDataSource, FSCalendarDelegate {

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: AdaptSize(451))
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(6))
        return view
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()

    var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "go"), for: .normal)
        button.setTitleColor(UIColor.gray3, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        return button
    }()

    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "go"), for: .normal)
        button.setTitleColor(UIColor.gray3, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: 14)
        button.titleLabel?.textAlignment = .right
        return button
    }()

    var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.headerHeight                    = .zero
        calendar.weekdayHeight                   = AdaptSize(33)
        calendar.locale                          = Locale(identifier: "zh-CN")
        calendar.scrollDirection                 = .horizontal
        calendar.backgroundColor                 = .white
        calendar.appearance.weekdayTextColor     = .black3
        calendar.appearance.weekdayFont          = .regularFont(ofSize: AdaptSize(12))
        calendar.appearance.titleDefaultColor    = .black1
        calendar.appearance.titleFont            = .regularFont(ofSize: AdaptSize(15))
        calendar.appearance.todayColor           = .black1
        calendar.appearance.borderSelectionColor = .clear
        calendar.appearance.selectionColor       = .orange1
//        calendar.calendarWeekdayView.weekdayLabels = {
//            let arrayLabels = [UILabel]()
//
//            return arrayLabels
//        }()
        return calendar
    }()

    var downButton: YXButton = {
        let button = YXButton(.theme, frame: .zero)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()

    var selectedBlock: ((Date)->Void)?
    var selectedDate: Date

    init(frame: CGRect, selected: Date) {
        self.selectedDate = selected
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateDate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(leftButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightButton)
        contentView.addSubview(calendarView)
        contentView.addSubview(downButton)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(30))
            make.width.equalTo(AdaptSize(60))
            make.centerY.equalTo(titleLabel)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(26))
            make.left.equalTo(leftButton.snp.right)
            make.right.equalTo(rightButton.snp.left)
            make.height.equalTo(AdaptSize(24))
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(30))
            make.width.equalTo(AdaptSize(60))
            make.centerY.equalTo(titleLabel)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        calendarView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(25))
            make.width.equalToSuperview().offset(AdaptSize(-80))
            make.bottom.equalTo(downButton.snp.top).offset(AdaptSize(-46))
        }
        downButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(273), height: AdaptSize(42)))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-40))
        }
    }

    override func bindProperty() {
        self.calendarView.delegate   = self
        self.calendarView.dataSource = self
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.backgroundView.addGestureRecognizer(tapAction)
        self.downButton.addTarget(self, action: #selector(downAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    @objc private func downAction() {
        self.selectedBlock?(self.selectedDate)
        self.hide()
    }

    @objc private func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.contentView.transform          = .identity
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    override func show() {
        super.show()
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.contentView.transform          = CGAffineTransform(translationX: 0, y: AdaptSize(-451))
        }
    }

    internal func updateDate() {
        let titleStr = NSDate.string(with: self.selectedDate, format: "yyyy年 M月")
        let leftStr: String = {
            let lastMonthStr = ((self.selectedDate as NSDate).offsetMonths(-1) as NSDate).string(withFormat: "M") ?? ""
            return String(format: "%@月", lastMonthStr)
        }()
        let rightStr: String = {
            let nextMonthStr = ((self.selectedDate as NSDate).offsetMonths(1) as NSDate).string(withFormat: "M") ?? ""
            return String(format: "%@月", nextMonthStr)
        }()
        self.titleLabel.text = titleStr
        self.leftButton.setTitle(leftStr, for: .normal)
        self.rightButton.setTitle(rightStr, for: .normal)
        
    }

    // MARK: ==== FSCalendar Delegate & Datasource

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let number = Int.random(in: 0...9)
        if number % 2 == 0 {
//            cell.appearance.titleDefaultColor = UIColor.black1
            cell.titleLabel.textColor = UIColor.black1
        } else {
            cell.titleLabel.textColor = UIColor.black4
        }
        if date == self.selectedDate {
            cell.titleLabel.textColor = UIColor.white
            cell.backgroundColor = UIColor.orange1
        }
    }
}
