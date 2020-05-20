//
//  YXLearnConfig.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


/// 学习配置
protocol YXLearnConfig {
    /// 哪本书
    var bookId: Int { get set }
        
    /// 哪个单元
    var unitId: Int { get set }

    /// 哪个复习计划
    var planId: Int { get set }

    /// 学习类型
    var learnType: YXExerciseDataType { get set }
}


class YXLearnConfigImpl: YXLearnConfig {
    var bookId: Int = 0
    var unitId: Int = 0
    var planId: Int = 0
    var learnType: YXExerciseDataType = .base
    
    init(bookId: Int, unitId: Int, planId: Int, learnType: YXExerciseDataType) {
        self.bookId     = bookId
        self.unitId     = unitId
        self.planId     = planId
        self.learnType  = learnType
    }
}

/// 基础学习配置
class YXBaseLearnConfig: YXLearnConfigImpl {
    init(bookId: Int = 0, unitId: Int = 0, learnType: YXExerciseDataType = .base) {
        super.init(bookId: bookId, unitId: unitId, planId: 0, learnType: learnType)
    }
}


/// 智能复习配置
class YXAIReviewLearnConfig: YXLearnConfigImpl {
    init(learnType: YXExerciseDataType = .aiReview) {
        super.init(bookId: 0, unitId: 0, planId: 0, learnType: learnType)
    }
}


/// 错题本配置
class YXWrongLearnConfig: YXAIReviewLearnConfig {
    override init(learnType: YXExerciseDataType = .wrong) {
        super.init(learnType: learnType)
    }
}


/// 复习计划配置
class YXReviewPlanLearnConfig: YXLearnConfigImpl {
    init(planId: Int = 0, learnType: YXExerciseDataType = .planReview) {
        super.init(bookId: 0, unitId: 0, planId: planId, learnType: learnType)
    }
}


/// 听力复习配置
class YXListenReviewLearnConfig: YXReviewPlanLearnConfig {
    override init(planId: Int = 0, learnType: YXExerciseDataType = .planListenReview) {
        super.init(planId: planId, learnType: learnType)
    }
}




