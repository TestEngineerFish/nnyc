//
//  YXExerciseServiceImpl+Build.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 出题逻辑，从数据库读取数据
extension YXExerciseServiceImpl {
    
    /// 加载学习进度
    func _loadStudyPropress() {
        // 1.获取本地记录
        self._loadStudyRecord()
        
        // 2. 加载答题选项
        if progress == .learning {
            self._loadExerciseOption()
        }
    }

    /// 加载学习记录
    func _loadStudyRecord() {
        if let model = studyDao.selectStudyRecordModel(config: learnConfig) {
            _studyRecord = model
            progress = _studyRecord.progress
            YXLog("查询当前学习记录")
        } else {
            YXLog("查询当前学习记录为空：", learnConfig.learnType, learnConfig.bookId, learnConfig.unitId, learnConfig.planId)
        }
    }
    
    /// 筛选数据
    func updateCurrentTurn() {

        // 当前轮是否做完(1可能刚进来，2做完)
        if turnDao.selectTurnFinishStatus(studyId: _studyId) {

            // 清空当前轮
            let r1 = turnDao.deleteCurrentTurn(studyId: _studyId)
            //  查询下一轮是否包含N3
            let hasN3 = turnDao.nextTurnHasN3Question(study: _studyId)
            if hasN3 {
                // 插入N3题
                turnDao.insertAllN3Step(study: _studyId)
            } else {
                // 插入新的轮
                turnDao.insertCurrentTurn(studyId: _studyId)
            }

            YXLog("\n清空当前轮", r1)
        }
    }
    
    /// 查找一个练习
    func _findExercise() -> YXExerciseModel? {
        guard var exerciseModel = turnDao.selectExercise(studyId: _studyId) else {
            YXLog("当前轮没有数据了")
            return nil
        }
        if exerciseModel.type == .newLearnMasterList {
            // -- N3的题
            let exerciseModel = self._finedN3Exercise(exercise: exerciseModel)
            return exerciseModel
        } else {
            // -- 正常出题
            // 初始化单词对象
            exerciseModel.word = self._queryWord(wordId: exerciseModel.wordId)
            // 初始化选项
            let exerciseModel = _processExerciseOption(exercise: exerciseModel)
            return exerciseModel
        }
    }
    
    /// 查找N3题型
    func _finedN3Exercise(exercise model: YXExerciseModel) -> YXExerciseModel? {
        var n3List = [YXExerciseModel]()
        let es = turnDao.selectAllStep(studyId: _studyId)
        for e in es {
            if e.type == .newLearnMasterList {
                var newE = e
                newE.word = _queryWord(wordId: e.wordId)
                n3List.append(newE)
            }
        }
        var exerciseContainer    = model
        exerciseContainer.n3List = n3List
        return exerciseContainer
    }

    /// 查询单词内容
    func _queryWord(wordId: Int) -> YXWordModel? {
        if learnConfig.learnType == .base {
            return wordDao.selectWord(bookId: learnConfig.bookId, wordId: wordId)
        } else {
            return wordDao.selectWord(wordId: wordId)
        }
    }
    
    /// 打印
    func _printCurrentTurn() {
//        let currentGroupIndex = _studyRecord.currentGroup
//        let currentTurnIndex = _studyRecord.currentTurn
//        let currentTurnArray = turnDao.selectCurrentTurn(studyId: _studyId)
//        YXLog(String(format: "第\(currentGroupIndex)组, 第\(currentTurnIndex)轮，数量：%ld", currentTurnArray.count))
//        for (index, e) in currentTurnArray.enumerated() {
//            let word = _queryWord(wordId: e.wordId)
//            YXLog(String(format: "%ld(%ld)  id = %ld, word = %@, step = %ld, backup = %ld, type = %@, finish = %ld",
//                         index + 1, e.isCurrentTurnFinish, e.wordId, word?.word ?? "", e.step, e.isBackup, e.type.rawValue, e.isCurrentTurnFinish))
//            
//        }
    }
}
