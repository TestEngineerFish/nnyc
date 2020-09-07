//
//  YXNewLearningResultCalendarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXNewLearningResultCalendarViewProtocol: NSObjectProtocol {
    func calendarPunchAction()
}

class YXNewLearningResultCalendarView: YXView, FSCalendarDataSource, FSCalendarDelegate, YXCalendarCellProtocol {

    weak var delegate: YXNewLearningResultCalendarViewProtocol?
    var validDict = [String:YXCalendarStudyModel]()

    var todayCell: YXCalendarCell?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(15))
        label.textAlignment = .center
        return label
    }()
    var calendarView: FSCalendar = {
        let weekValue = ["SUM", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        let calendar = FSCalendar()
        calendar.headerHeight    = .zero
        calendar.weekdayHeight   = AdaptSize(32)
        calendar.locale          = Locale(identifier: "zh-CN")
        calendar.scrollDirection = .horizontal
        calendar.appearance.todayColor               = .clear
        calendar.appearance.todaySelectionColor      = .clear
        calendar.appearance.titleTodayColor          = .gray1
        calendar.appearance.titleDefaultColor        = UIColor.gray1
        calendar.appearance.titlePlaceholderColor    = UIColor.black4
        calendar.appearance.weekdayFont              = UIFont.regularFont(ofSize: AdaptSize(12))
        calendar.appearance.weekdayTextColor         = UIColor.hex(0xBBBBBB)
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.scrollEnabled   = false
        calendar.allowsSelection = false
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
        self.requestCalendarData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(titleLabel)
        self.addSubview(calendarView)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
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
    }

    // MARK: ==== Request ====
    private func requestCalendarData() {
        let request = YXCalendarRequest.getMonthly(time: Int(NSDate().timeIntervalSince1970))
        YYNetworkService.default.request(YYStructResponse<YXCalendarModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else {
                return
            }
            self.validDict.removeAll()
            model.studyModel.forEach { (studyModel) in
                let date = NSDate(timeIntervalSince1970: Double(studyModel.time ?? 0))
                self.validDict.updateValue(studyModel, forKey: date.formatYMD())
            }
            // 容错处理（防止后台未及时返回当前学习数据）
            if let todayModel = YXCalendarStudyModel(JSON: ["date": Int(Date().timeIntervalSince1970), "status": 1]) {
                self.validDict.updateValue(todayModel, forKey: NSDate().formatYMD())
            }
            self.calendarView.reloadData()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Event ====

    func setData() {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MMMM.YYYY"
        dateFormatter.locale     = Locale(identifier: "en")
        self.titleLabel.text     = dateFormatter.string(from: Date())
    }

    // MARK: ==== FSCalendarDelegate ====
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let model = self.validDict[(date as NSDate).formatYMD()] {
            cell.removeAllSubviews()
            let isTody = (date as NSDate).isToday()
            let customCellSize = CGSize(width: AdaptSize(40), height: AdaptSize(45))
            let customCell = YXCalendarCell(model: model, isToday: isTody, frame: CGRect(origin: .zero, size: customCellSize))
            customCell.delegate = self
            cell.addSubview(customCell)
            customCell.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(customCellSize)
            }
            if isTody {
                self.todayCell = customCell
            }
        } else {
            cell.titleLabel.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
    }

    // MARK: ==== YXCalendarCellProtocol ====
    func clickAction() {
        self.delegate?.calendarPunchAction()
    }

}
