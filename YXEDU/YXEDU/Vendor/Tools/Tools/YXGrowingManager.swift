//
//  YXGrowingManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import GrowingCoreKit

struct YXGrowingManager {
    static var share = YXGrowingManager()
    /// 上报学习时间
    var startDate: NSDate?
    /// 上报新学数量
    var newLearnNumber = 0
    /// 上报练习数量
    var exerciseNumber = 0

    // TODO: ---- 事件 ----

    mutating func uploadLearnStop() {
        guard let _date = startDate else { return }
        let learnTime = abs(Int(_date.timeIntervalSinceNow))
        let params    = ["study_break_time":learnTime, "study_break_new_study" : newLearnNumber, "study_break_step": exerciseNumber]
        Growing.track("study_break", withVariable: params)
        self.newLearnNumber = 0
        self.exerciseNumber = 0
    }

    /// 上报新学完成事件
    func uploadNewLearnFinished() {
        Growing.track("main_finish_new_study")
        YYCache.set(true, forKey: .newLearnReportGIO)
    }

    /// 主流程学习完成
    func uploadLearnFinished() {
        Growing.track("main_finish_study")
    }

    // TODO: ---- 用户变量 ----

    /// 七年级跳过新学上报
    func uploadSkipNewLearn() {
        let value = YXConfigure.shared().isUploadGIO ? "7年级跳过新学" : "7年级参照组"
        Growing.setPeopleVariableWithKey("new_study_test", andStringValue: value)
    }

    /// 换书时上传书信息
    func uploadChangeBook(grade: String?, versionName: String?) {
        if let _grade = grade {
            Growing.setPeopleVariableWithKey("user_grade", andStringValue: _grade)
            YXLog("Growing--------grade: -----", _grade)
        }
        if let _versionName = versionName {
            Growing.setPeopleVariableWithKey("user_book_version", andStringValue: _versionName)
            YXLog("Growing--------versionName: -----", _versionName)
        }
    }

}
