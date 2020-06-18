//
//  YXExerciseServiceImpl+Data.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 处理网络数据，存储到数据库
extension YXExerciseServiceImpl {
    
    /// 处理从网络请求的数据
    /// - Parameter result: 网络数据
    func _processData(completion: (() -> Void)?) {
        if _resultModel?.wordList.isEmpty == .some(true) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(learnConfig.learnType)")
            progress = .empty
            completion?()
            return
        }
        
        self.ruleType = _resultModel?.ruleType ?? .p0
        
        // 插入学习记录
        let recordId = self._processStudyRecord()
        if recordId == 0 {
            YXLog("插入学习记录失败")
            return
        }
        
        // 如果不是基础学习类型，bookId和unitId是虚拟的
        // 注意，必须放在记录表下面赋值，因为记录表是不能插入虚拟ID的，否则复习未做完，下次进来会重复插入数据
//        self.learnConfig.bookId = _resultModel?.bookId ?? 0
//        self.learnConfig.unitId = _resultModel?.unitId ?? 0
        
        
        // 插入单词数据
        self._processExercise(recordId: recordId)
        
        // 加载答题选项
        self._loadExerciseOption()

        completion?()
    }
    
    
    /// 处理学习记录
    func _processStudyRecord() -> Int {
        return self.studyDao.insertStudyRecord(learn: learnConfig)
    }

    /// 单词和学习步骤数据
    /// - Parameter result: 网络数据
    func _processExercise(recordId: Int) {
        guard let exerciseWordModelList = self._resultModel?.wordList else {
            return
        }
        // 处理单词列表
        for exerciseWordModel in exerciseWordModelList {
            guard let wordModel = exerciseWordModel.wordModel, let wordId = wordModel.wordId else {
                continue
            }
            // 插入练习数据
            let exerciseId = exerciseDao.insertExercise(learnType: learnConfig.learnType, study: recordId, wordModel: wordModel, nextStep: exerciseWordModel.startStep)

            // 插入Step数据
            exerciseWordModel.stepModelList.forEach { (stepModel) in
                stepDao.insertWordStep(study: recordId, eid: exerciseId, wordModel: wordModel, stepModel: stepModel)
            }
            YXLog("插入练习数据，单词ID：", wordId, exerciseId > 0 ? " 成功" : " 失败")
        }
    }
}

