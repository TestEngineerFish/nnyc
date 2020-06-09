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
    
    /// 加载学习记录
    func _loadStudyRecord() {
        if let record = studyDao.selectStudyRecordModel(config: learnConfig) {
            self._studyRecord = record
            YXLog("查询当前学习记录")
        }
    }

    /// 更新分组下标
    func _updateCurrentGroup() {
        // 未完成的组下标
        if let group = stepDao.selectCurrentGroup(studyId: _studyId) {
            if group > _studyRecord.currentGroup {
                // 新的一组开始
                let r1 = studyDao.updateCurrentGroup(studyId: _studyId, group: group)
                
                // 新的一组开始后，重置当前轮的下标为 -1
                let r2 = studyDao.updateCurrentTurn(learn: learnConfig, turn: -1)
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
    
    /// 筛选数据
    func _filterExercise() {
        
        // 当前轮是否做完
        if turnDao.selectTurnFinishStatus(studyId: _studyId) {
            
            // 新的轮开始
            _studyRecord.currentTurn = _studyRecord.currentTurn + 1
            
            // 查找当前组(group)未做的最小step
            // 例如只有s1 s3 s4时， s1全做对，因为要满足Turn>=Step,T2轮的就没法做s3了，T3轮就没法做s4
            if let minStep = stepDao.selectUnFinishMinStep(studyRecord: _studyRecord) {
                if minStep > _studyRecord.currentTurn {
                    _studyRecord.currentTurn = minStep
                    // 有跳跃step时，保持到表中
                    YXLog("筛选数据， 更新轮下标, 跳跃 下标", minStep)
                }
            }
            
            // 更新轮下标
            let r1 = studyDao.updateCurrentTurn(learn: learnConfig, turn: _studyRecord.currentTurn)
            
            // 清空当前轮
            let r2 = turnDao.deleteCurrentTurn(studyId: _studyId)
            
//            let newTurn = turnDao.selectNewTurn(studyId: _studyId, group: _studyRecord.currentGroup)
            
            // 插入新的轮
            let r3 = turnDao.insertCurrentTurn(studyId: _studyId, group: _studyRecord.currentGroup)
            
            // 把上轮做错的状态恢复成未做
            let r4 = stepDao.updatePreviousWrongStatus(studyId: _studyId)
            
            YXLog("\n筛选数据， 更新轮下标", r1,
                  "\n清空当前轮", r2,
                  "\n插入新的轮 ,study_id:\(_studyId)", r3,
                  "\n重置上轮做错的 ", r4)
        }
    }
    
    /// 查找一个练习
    func _findExercise() -> YXExerciseModel? {
        // 打印
        _printCurrentTurn()
        
        guard var exercise = turnDao.selectExercise(studyId: _studyId) else {
            YXLog("当前轮没有数据了")
            return nil
        }
        
        // 是否有N3的题
        if let model = _finedN3Exercise(exercise: exercise) {
            return model
        }
        
        if _isConnectionType(model: exercise) {
            // 连线题
            return _findConnectionExercise(exercise: exercise)
        } else {
            // 正常出题
            exercise.word = _queryWord(wordId: exercise.wordId)
            return _processExerciseOption(exercise: exercise)
        }
    }
    
    /// 查找N3题型
    func _finedN3Exercise(exercise: YXExerciseModel) -> YXExerciseModel? {
        if exercise.step == 0 && exercise.type == .newLearnMasterList {
            var n3List = [YXExerciseModel]()
            let es = turnDao.selectCurrentTurn(studyId: _studyId)
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
    
    
    
    /// 查找一个连线题，有可能是备选题
    /// - Parameters:
    ///   - step:
    ///   - type:
    func _findConnectionExercise(exercise: YXExerciseModel) -> YXExerciseModel? {
        var connectionExercises = turnDao.selectExercise(studyId: _studyId, type: exercise.type, step: exercise.step, size: 4)
        
        // 填充word
        connectionExercises = _fillConnectionWordModel(exercises: connectionExercises)
        
        // 连线题中，是否有单词拼写相同的，如果有都用备选题
        let sameWords = _sameWords(connectionExercises: connectionExercises)
        
        // 有相同拼写，或者连线只有一个，都用备选题
        if sameWords.count > 0 || connectionExercises.count == 1 {
            let e = connectionExercises.first
            if var backupExercise = turnDao.selectBackupExercise(studyId: _studyId, exerciseId: e?.eid ?? 0, step: e?.step ?? 0) {
                backupExercise.word = _queryWord(wordId: backupExercise.wordId)
                return _processExerciseOption(exercise: backupExercise)
            } else {
                YXLog("备选题为空， 出错")
                return nil
            }
        }
        
        // 正常出连线题
        if connectionExercises.count > 1 {
            return _processConnectionExerciseOption(exercises: connectionExercises)
        }
        return nil
    }
    
    /// 连线题中，是否有单词拼写相同的
    func _sameWords(connectionExercises: [YXExerciseModel]) -> [Int] {
        var ids: [Int] = []
        for exercise in connectionExercises {
            for e in connectionExercises {
                if exercise.word?.wordId == e.word?.wordId {
                    continue
                }
                if exercise.word?.word != nil && exercise.word?.word == e.word?.word {
                    ids.append(exercise.word?.wordId ?? 0)
                }
            }
        }
        
        return ids
    }
    
    
    /// 填充连线题的单词
    /// - Parameter exercises:
    func _fillConnectionWordModel(exercises: [YXExerciseModel]) -> [YXExerciseModel] {
        var es: [YXExerciseModel] = []
        for e in exercises {
            var model = e
            model.word = _queryWord(wordId: e.wordId)
            es.append(model)
        }
        return es
    }
    
    
    /// 查询单词内容
    /// - Parameter wordId:
    func _queryWord(wordId: Int) -> YXWordModel? {
        if learnConfig.learnType == .base {
            return wordDao.selectWord(bookId: learnConfig.bookId, wordId: wordId)
        } else {
            return wordDao.selectWord(wordId: wordId)
        }
    }
    
    
    func _printCurrentTurn() {
        let currentGroupIndex = _studyRecord.currentGroup
        let currentTurnIndex = _studyRecord.currentTurn
        let currentTurnArray = turnDao.selectCurrentTurn(studyId: _studyId)
        YXLog(String(format: "第\(currentGroupIndex)组, 第\(currentTurnIndex)轮，数量：%ld", currentTurnArray.count))
        for e in currentTurnArray {
            YXLog(String(format: "id = %ld, word = %@", e.wordId, e.word?.word ?? "", "backup = ", e.isBackup))
            YXLog(String(format: "step = %ld, type = %@, turn_finish = %ld", e.step, e.type.rawValue, e.isCurrentTurnFinish))
        }
    }
}
