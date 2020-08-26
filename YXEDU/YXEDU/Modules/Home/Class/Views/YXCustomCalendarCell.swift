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
    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.removeAllSubviews()
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
