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
            ruleType = _studyRecord.ruleType
            progress = _studyRecord.progress            
            YXLog("查询当前学习记录")
        } else {
            YXLog("查询当前学习记录为空：", learnConfig.learnType, learnConfig.bookId, learnConfig.unitId, learnConfig.planId)
        }
    }

    
    /// 更新分组下标
    func _updateCurrentGroupIndex() {
        // 未完成的组下标
        if let group = stepDao.selectCurrentGroup(studyId: _studyId) {
            if group > _studyRecord.currentGroup {
                // 新的一组开始
                _studyRecord.currentGroup = group
                
                // 更新组下标
                let r1 = studyDao.updateCurrentGroup(studyId: _studyId, group: group)
                
                // 新的一组开始后，重置当前轮的下标为 -1
                let r2 = studyDao.updateCurrentTurn(studyId: _studyId, turn: -1)
                if r2 {
                    _studyRecord.currentTurn = -1
                }
                YXLog("新组开始, 第\(group)组, ", r1, r2)
            }
        } else {
            // 没有分组，就是学习完成，等待上报
            progress = .unreport
            
            // 更新未待上报状态
            let r1 = studyDao.updateProgress(studyId: _studyId, progress: progress)
            YXLog("当前学习已经完成，等待上报", r1)
        }
    }
    
    
    /// 更新轮次下标
    func _updateCurrentTurnIndex() {
        // 新的轮开始
        _studyRecord.currentTurn = _studyRecord.currentTurn + 1
        
        // 查找当前组(group)未做的最小step
        if let minStep = stepDao.selectUnFinishMinStep(studyId: _studyId, group: _studyRecord.currentGroup) {
            // 例如只有s1 s3 s4时， s1全做对，因为要满足Turn>=Step,T2轮的就没法做s3了，T3轮就没法做s4
            if minStep > _studyRecord.currentTurn {
                // 使用跳跃的 step
                _studyRecord.currentTurn = minStep
                YXLog("轮下标跳跃至 turn_index:", minStep)
            }
        }
        
        // 保存轮下标到数据表
        let r1 = studyDao.updateCurrentTurn(studyId: _studyId, turn: _studyRecord.currentTurn)
        YXLog("新轮开始 turn_index:", _studyRecord.currentTurn, r1)
    }
    
    
    /// 筛选数据
    func _filterExercise() {
        // 更新分组下标
        self._updateCurrentGroupIndex()
        
        // 当前轮是否做完(1可能刚进来，2做完)
        if turnDao.selectTurnFinishStatus(studyId: _studyId) {
            
            // 更新轮次下标
            self._updateCurrentTurnIndex()
            
            // 清空当前轮
            let r1 = turnDao.deleteCurrentTurn(studyId: _studyId)
            
            // 插入新的轮
            let r2 = turnDao.insertCurrentTurn(studyId: _studyId, group: _studyRecord.currentGroup)
            
            // 把上轮做错的状态恢复成未做
            let r3 = stepDao.updatePreviousWrongStatus(studyId: _studyId)
            
            YXLog("\n清空当前轮", r1,
                  "\n插入新的轮 ,study_id:\(_studyId)", r2,
                  "\n重置上轮做错的 ", r3)
        }
    }
    
    /// 查找一个练习
    func _findExercise() -> YXExerciseModel? {
        guard var exercise = turnDao.selectExercise(studyId: _studyId) else {
            YXLog("当前轮没有数据了")
            return nil
        }
        
        // 是否有N3的题
        if let model = _finedN3Exercise(exercise: exercise) {
            return model
        }
        // 正常出题
        exercise.word = _queryWord(wordId: exercise.wordId)
        return _processExerciseOption(exercise: exercise)
    }
    
    
    /// 查找N3题型
    func _finedN3Exercise(exercise: YXExerciseModel) -> YXExerciseModel? {
        if exercise.step == 0 && exercise.type == .newLearnMasterList {
            var n3List = [YXExerciseModel]()
            let es = turnDao.selectAllExercise(studyId: _studyId)
            for e in es {
                if e.type == .newLearnMasterList {
                    var newE = e
                    newE.word = _queryWord(wordId: e.wordId)
                    n3List.append(newE)
                }
            }
            var exerciseContainer = exercise
            exerciseContainer.n3List = n3List
            return exerciseContainer
        }
        return nil
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
        let currentGroupIndex = _studyRecord.currentGroup
        let currentTurnIndex = _studyRecord.currentTurn
        let currentTurnArray = turnDao.selectCurrentTurn(studyId: _studyId)
        YXLog(String(format: "第\(currentGroupIndex)组, 第\(currentTurnIndex)轮，数量：%ld", currentTurnArray.count))
        for (index, e) in currentTurnArray.enumerated() {
            let word = _queryWord(wordId: e.wordId)
            YXLog(String(format: "%ld(%ld)  id = %ld, word = %@, step = %ld, backup = %ld, type = %@, finish = %ld",
                         index + 1, e.isCurrentTurnFinish, e.wordId, word?.word ?? "", e.step, e.isBackup, e.type.rawValue, e.isCurrentTurnFinish))
            
        }
    }
}
