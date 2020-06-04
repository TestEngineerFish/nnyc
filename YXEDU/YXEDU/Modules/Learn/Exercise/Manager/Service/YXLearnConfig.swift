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
    var learnType: YXLearnType { get set }
}

/// 学习配置，基础实现
class YXLearnConfigImpl: YXLearnConfig {
    var bookId: Int = 0
    var unitId: Int = 0
    var planId: Int = 0
    var learnType: YXLearnType = .base
    
    init(bookId: Int, unitId: Int, planId: Int, learnType: YXLearnType) {
        self.bookId     = bookId
        self.unitId     = unitId
        self.planId     = planId
        self.learnType  = learnType
    }
}

/// 基础学习配置
class YXBaseLearnConfig: YXLearnConfigImpl {
    /// 基础学习时，必须要传 bookId和unitId，要缓存进度
    init(bookId: Int = 0, unitId: Int = 0, learnType: YXLearnType = .base) {
        super.init(bookId: bookId, unitId: unitId, planId: 0, learnType: learnType)
    }
}


/// 复习配置的基类
class YXReviewLearnConfig: YXLearnConfigImpl {
    init(planId: Int, learnType: YXLearnType) {
        super.init(bookId: 0, unitId: 0, planId: planId, learnType: learnType)
    }
}

/// 智能复习配置
class YXAIReviewLearnConfig: YXReviewLearnConfig {
    init(learnType: YXLearnType = .aiReview) {
        super.init(planId: 0, learnType: learnType)
    }
}


/// 错题本配置
class YXWrongLearnConfig: YXAIReviewLearnConfig {
    override init(learnType: YXLearnType = .wrong) {
        super.init(learnType: learnType)
    }
}


/// 复习计划配置
class YXReviewPlanLearnConfig: YXReviewLearnConfig {
    override init(planId: Int = 0, learnType: YXLearnType = .planReview) {
        super.init(planId: planId, learnType: learnType)
    }
}


/// 听力复习配置
class YXListenReviewLearnConfig: YXReviewPlanLearnConfig {
    override init(planId: Int = 0, learnType: YXLearnType = .planListenReview) {
        super.init(planId: planId, learnType: learnType)
    }
}




