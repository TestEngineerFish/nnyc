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
    case none       = 1     // 没有学习记录，可能是首次，也可能是学完了
    case learning   = 2     // 学习中【未学完】
    case unreport   = 3     // 已学完【未上报】
    case empty      = 4     // 学习数据异常
}

//MARK: - 练习出题逻辑管理器
/// 练习出题逻辑管理器
protocol YXExerciseService {
    
    
    //MARK: - 属性
    // ----------------------------
    var learnConfig: YXLearnConfig { get set }
    
    /// 练习规则
    var ruleType: YXExerciseRule { get }
    
    /// 练习进度
    var progress: YXExerciseProgress { get }
    
    
    //MARK: - 方法
    // ----------------------------
    /// 初始化
    func initService()

    func addStudyCount()
    
    /// 设置开始学习时间
    func setStartTime()
    
    /// 获取一个练习数据
    /// - returns: 练习对象，如果做完则返回nil
    func fetchExerciseModel() -> YXExerciseModel?
    
    /// 加载网络数据
    func fetchExerciseResultModels(completion: ((_ result: Bool, _ msg: String?) -> Void)?)
        
    /// 如果本地没有学完，获取练习前，需要加载
//    func loadLocalExercise()
    
    /// 做题动作，不管答题对错，都需要调用次方法修改相关状态
    /// - Parameters:
    ///   - exerciseModel:  练习数据
    func normalAnswerAction(exercise model: YXExerciseModel)

    func connectionAnswerAction(wordId: Int, step: Int, right: Bool)
    
    /// 连线题型 ，连线题所有项全部连完
    func updateConnectionExerciseFinishStatus(exerciseModel: YXExerciseModel, right: Bool)
    
    /// 获得未学完的新学单词数
    func getNewWordCount() -> Int

    /// 获得未学完的复习单词数
    func getReviewWordCount() -> Int

    /// 上报学习数据
    /// - Parameters:
    ///   - completion: 完成回调
    func report(completion: ((_ result: Bool, _ dict: [String:Int]) -> Void)?)

    /// 是否需要显示单词详情页
    /// - Parameters:
    ///   - wordId: 单词ID
    ///   - step:   步骤ID
    func isShowWordDetail(wordId: Int, step: Int) -> Bool
    
    
    /// 在当前轮次中，是否有连线错误
    /// - Parameters:
    ///   - wordId: 单词ID
    ///   - step:   step
    func hasErrorInCurrentTurn(wordId: Int, step: Int) -> Bool
    
    @discardableResult
    func cleanExercise() -> Bool

}


extension YXExerciseService {
    
}

