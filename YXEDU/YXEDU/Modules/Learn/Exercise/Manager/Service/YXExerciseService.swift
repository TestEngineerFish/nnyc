//
//  YXExerciseService.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

//两种方法
//C++ ==> Objective-C++ / Objective-C ==> Swift
//C++ ==> C ==> Swift

//MARK: - 练习单词分类
/// 练习单词分类
enum YXExerciseWordType: Int {
    case new = 1        // 新学
    case exercise = 2   // 训练
    case review = 3     // 复习
    
    var desc: String {
        if self == .new {
            return "新学"
        } else if self == .exercise {
            return "训练"
        } else {
            return "复习"
        }
        
    }
}

//MARK: - 练习进度

/// 练习进度
enum YXExerciseProgress: Int {
    case none = 0       // 空数据
    case learning = 1   // 学习中【未学完】
    case finished = 2   // 已学完【未上报】
    case reported = 3   // 已上报
}

//MARK: - 练习出题逻辑管理器
/// 练习出题逻辑管理器
protocol YXExerciseService {
    
    
    //MARK: - 属性
    // ----------------------------
    var learnConfig: YXLearnConfig { get set }
    
    /// 练习规则
    var ruleType: YXExerciseRuleType { get }
    
    /// 练习进度
    var exerciseProgress: YXExerciseProgress { get }
    
    
    //MARK: - 方法
    // ----------------------------
    /// 获取一个练习数据
    func fetchExerciseModel() -> YXWordExerciseModel?
    
    
    /// 做题动作，不管答题对错，都需要调用次方法修改相关状态（连线题单个选项的对错有其他的方法处理）
    /// - Parameters:
    ///   - exerciseModel:  练习数据
    ///   - right:          对错
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool)
    
    
    /// 连线题，仅单个选项的做题动作处理
    /// - Parameters:
    ///   - exerciseModel:  练习数据
    ///   - right:          对错
    ///   - optionIndex:    选项下标，做的是连线题的哪一个选项
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool, optionIndex: Int)
    
    
    /// 是否需要显示单词详情页
    /// - Parameters:
    ///   - wordId: 单词ID
    ///   - step:   步骤ID
    func isShowWordDetail(wordId: Int, step: Int) -> Bool
    
    
    /// 在当前轮次中，是否有连线错误
    /// - Parameters:
    ///   - wordId: 单词ID
    ///   - step:   step
    func hasErrorInCurrentTurn(wordId: Int, step: Int)

}


extension YXExerciseService {
    /// 每批新学的大小限制
    var newWordBatchSize: Int {
        return ruleType == .a1 || ruleType == .a2 ? 2 : 5
    }
    
    /// 每批训练的大小限制
    var exerciseWordBatchSize: Int {
        return ruleType == .a1 || ruleType == .a2 ? 2 : 5
    }
    
    /// 每批复习的大小限制
    var reviewWordBatchSize: Int {
        return ruleType == .a1 || ruleType == .a2 ? 2 : 5
    }
    
    
}

