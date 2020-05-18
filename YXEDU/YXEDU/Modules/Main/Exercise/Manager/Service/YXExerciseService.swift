//
//  YXExerciseService.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


/// 练习状态
enum YXExerciseStatus: Int {
    case learning = 1   // 学习中【未学完】
    case finished = 2   // 已学完【未上报】
    case reported = 3   // 已上报
}

/// 练习出题逻辑管理器
protocol YXExerciseService {
    
    //MARK: - 属性
    // ----------------------------
    /// 哪本书
    var bookId: Int { get set }
        
    /// 哪个单元
    var unitId: Int { get set }
    
    /// 数据类型
    var dataType: YXExerciseDataType { get set }
    
    /// 练习规则
    var ruleType: YXExerciseRuleType { get }
    
    /// 练习状态
    var exerciseStatus: YXExerciseStatus { get }
    
    
    
    //MARK: - 方法
    // ----------------------------
    /// 获取一个练习数据
    func getExerciseModel() -> YXWordExerciseModel?
    
    
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
