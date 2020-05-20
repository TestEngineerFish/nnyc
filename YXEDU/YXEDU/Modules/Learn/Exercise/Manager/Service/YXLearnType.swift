//
//  YXLearnType.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


@objc protocol YXLearnType {
    
    /// 哪本书
    @objc optional
    var bookId: Int { get set }
        
    /// 哪个单元
    @objc optional
    var unitId: Int { get set }

    /// 哪个复习计划
    @objc optional
    var planId: Int { get set }

    /// 数据类型
    @objc optional
    var dataType: YXExerciseDataType { get set }
}


class YXBaseLearnType: YXLearnType {
    var bookId: Int = 0
    var unitId: Int = 0
    var dataType: YXExerciseDataType = .base
}


class YXWrongLearnType: YXLearnType {
    var dataType: YXExerciseDataType = .wrong
}


class YXReviewListenLearnType: YXLearnType {
    var planId: Int = 0
    var dataType: YXExerciseDataType = .planListenReview
}


class YXReviewPlanLearnType: YXLearnType {
    var planId: Int = 0
    var dataType: YXExerciseDataType = .planReview
}


class YXAILearnType: YXLearnType {
    var dataType: YXExerciseDataType = .aiReview
}
