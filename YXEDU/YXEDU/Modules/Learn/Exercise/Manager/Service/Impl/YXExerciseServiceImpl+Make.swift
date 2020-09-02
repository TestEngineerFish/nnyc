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
        if let model = studyDao.selectStudyRecordModel(learn: learnConfig) {
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
        if turnDao.selectTurnFinishStatus(study: _studyId) {
            // 清空当前轮
            let r1 = turnDao.deleteCurrentTurn(study: _studyId)
            //  查询下一轮是否包含N3
            let hasN3 = turnDao.nextTurnHasN3Question(study: _studyId)
            if hasN3 {
                // 插入N3题
                turnDao.insertAllN3Step(study: _studyId)
            } else {
                // 插入新的轮
                turnDao.insertCurrentTurn(study: _studyId)
            }

            YXLog("\n清空当前轮", r1)
        }
    }
    
    /// 查找一个练习
    func _findExercise(exercise model: inout YXExerciseModel) -> YXExerciseModel? {
        guard let wordId = model.word?.wordId else {
            YXLog("单词ID为空")
            return nil
        }
        if model.type == .newLearnMasterList {
            // -- N3的题
            let exerciseModel = self._finedN3Exercise(exercise: model)
            return exerciseModel
        } else {
            // -- 正常出题
            // 初始化单词对象
            if var _wordModel = self._queryWord(wordId: wordId, bookId: model.word?.bookId) {
                _wordModel.wordType = model.word?.wordType ?? .newWord
                model.word  = _wordModel
                // 选项初始化
                let _exerciseModel = _processExerciseOption(exercise: model)
                return _exerciseModel
            } else {
                // 找不到对应单词
                return nil
            }
        }
    }
    
    /// 查找N3题型
    func _finedN3Exercise(exercise model: YXExerciseModel) -> YXExerciseModel? {
        var n3List = [YXExerciseModel]()
        let exerciseModelList = turnDao.selectAllExercise(study: _studyId)
        for exerciseModel in exerciseModelList {
            if exerciseModel.type == .newLearnMasterList && exerciseModel.status != .right {
                var newExerciseModel    = exerciseModel
                newExerciseModel.word   = _queryWord(wordId: exerciseModel.wordId, bookId: exerciseModel.word?.bookId ?? 0)
                newExerciseModel.status = .wrong // 默认未掌握
                n3List.append(newExerciseModel)
            }
        }
        var exerciseContainer    = model
        exerciseContainer.n3List = n3List
        return exerciseContainer
    }

    /// 查询单词内容
    func _queryWord(wordId: Int, bookId: Int?) -> YXWordModel? {
        if let _bookId = bookId, let wordModel = wordDao.selectWord(bookId: _bookId, wordId: wordId) {
            return wordModel
        } else {
            return wordDao.selectWord(wordId: wordId)
        }
    }
    
    /// 打印
    func _printCurrentTurn() {
        let exerciseModelList = self.turnDao.selectAllExercise(study: _studyId)
        YXLog("当前轮数据：")
        exerciseModelList.forEach { (exerciseModel) in
            YXLog(exerciseModel.type.rawValue, exerciseModel.word?.wordId ?? 0, exerciseModel.word?.word ?? "")
        }
    }
}
