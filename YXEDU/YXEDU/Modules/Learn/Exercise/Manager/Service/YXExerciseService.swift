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


//MARK: - 练习进度

/// 练习进度
enum YXExerciseProgress: Int {
    case none       = 1     // 没有学习记录，可能是首次，也可能是学完了
    case learning   = 2     // 学习中【未学完】
    case unreport   = 3     // 已学完【未上报】
    case empty      = 4     // 学习数据异常，或者当天没有要学的
}

//MARK: - 练习出题逻辑管理器
/// 练习出题逻辑管理器
protocol YXExerciseService {
    
    //MARK: - 属性
    // ----------------------------
    /// 学习配置
    var learnConfig: YXLearnConfig { get set }
    
    /// 练习进度
    var progress: YXExerciseProgress { get }
    
    /// 获得未学完的新学单词数
    var newWordCount: Int { get }
    
    /// 获得未学完的复习单词数
    var reviewWordCount: Int { get }
    
    //MARK: - 方法
    // ----------------------------
    /// 初始化服务
    func initService()

    // TODO: ==== 做题 ====
    
    /// 加载网络数据
    /// - Parameters:
    ///   - isGenerate: 是否重新生成题型
    ///   - completion: 完成回调
    func fetchExerciseResultModels(isGenerate: Bool, completion: ((_ result: Bool, _ msg: String?) -> Void)?)

    /// 获取一个练习数据
    /// - returns: 练习对象，如果做完则返回nil
    func fetchExerciseModel() -> YXExerciseModel?

    /// 做题动作，不管答题对错，都需要调用此方法修改相关状态
    /// - Parameters:
    ///   - model: 练习对象
    ///   - isRemind: 是否点击的提示
    func answerAction(exercise model: YXExerciseModel, isRemind: Bool)

    /// 更新
    /// - Parameters:
    ///   - id: 学习流程表ID
    ///   - status: 学习进度状态
    func updateStudyProgress(study id: Int, progress status: YXExerciseProgress)

    // TODO: ==== 上报 ====

    /// 添加学习次数
    func addStudyCount()

    /// 设置开始学习时间
    func setStartTime()

    /// 获得开始学习时间
    func getStartTime(learn config: YXLearnConfig) -> NSDate?

    /// 获取所有单词总数
    func getAllWordAmount() -> Int

    /// 获得已学新学单词数量
    func getNewWordAmount() -> Int

    /// 获得已学复习单词数量
    func getReviewWordAmount() -> Int

    /// 更新学习时间
    func updateDurationTime()

    /// 上报学习数据
    /// - Parameters:
    ///   - completion: 完成回调
    func reportReport(completion: ((_ result: YXResultModel?, _ dict: [String:Int]) -> Void)?)

    // TODO: ====  清除数据 ====

    /// 删除当前的学习数据
    func cleanStudyRecord(hasNextGroup: Bool)

    /// 删除所有的学习数据
    func cleanAllStudyRecord()

}
