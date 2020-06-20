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

    /// 练习出题逻辑管理器
    var service: YXExerciseService = YXExerciseServiceImpl()


    // TODO: ---- 事件 ----

    mutating func uploadLearnStop(learn config: YXLearnConfig) {
        guard let _date = self.service.getStartTime(learn: config) else { return }
        let learnTime   = abs(Int(_date.timeIntervalSinceNow))
        let params      = ["study_break_time":learnTime,
                           "study_break_new_study" : newLearnNumber,
                           "study_break_step": exerciseNumber]
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

    /// 换书时上传书信息
    func uploadChangeBook(grade: String?, versionName: String?) {
        if let _grade = grade {
            Growing.setPeopleVariableWithKey("user_grade", andStringValue: _grade)
        }
        if let _versionName = versionName {
            Growing.setPeopleVariableWithKey("user_book_version", andStringValue: _versionName)
        }
    }

    /// 数据打点
    func biReport(learn config: YXLearnConfig, duration: Int,  study count: Int) {
          var typeName = "主流程"
          switch config.learnType {
              case .wrong:
                  typeName = "抽查复习"
              case .planListenReview:
                  typeName = "词单听写"
              case .planReview:
                  typeName = "词单复习"
              case .aiReview:
                  typeName = "智能复习"
              default:
                  typeName = "主流程"
          }

          let bid = (YYCache.object(forKey: .currentChooseBookId) as? Int) ?? 0
          let grade = YXWordBookDaoImpl().selectBook(bookId: bid)?.gradeId ?? 0

          let studyResult: [String : Any] = [
              "study_grade" : "\(grade)",      //学习书本年级
              "study_cost_time" : duration,   //学习时间
              "study_count" : count,
              "study_type" : typeName
          ]
          Growing.track("study_result", withVariable: studyResult)
      }

}
