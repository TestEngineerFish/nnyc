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
    
    func loadProgressStatus() {
        
    }

    
    /// 筛选数据
    func _filterExercise() {
        let studyId = self.studyDao.getStudyID(learn: learnConfig)
        
        // 当前轮是否做完
        if turnDao.selectTurnFinishStatus(studyId: studyId) {
            currentTurnIndex += 1
            
            //更新轮下标
            let r1 = studyDao.updateCurrentTurn(learn: learnConfig, turn: currentTurnIndex)
            
            // 清空当前轮
            let r2 = turnDao.deleteCurrentTurn(studyId: studyId)
            
            // 插入新的轮
            let r3 = turnDao.insertCurrentTurn(studyId: studyId)
            
            YXLog("筛选数据， 更新轮下标", r1, "清空当前轮", r2, "插入新的轮 ,id", studyId, r3)
        }
    }
    
    /// 查找一个练习
    func _findExercise() -> YXExerciseModel? {
        guard var exercise = turnDao.selectExercise() else {
            YXLog("当前轮没有数据了")
            return nil
        }
        // 有连线题
        if isConnectionType(model: exercise) {
            return _findConnectionExercise(exercise: exercise)
        } else {// 正常返回
            exercise.word = _selectWord(wordId: exercise.wordId)
            return processExerciseOption(exercise: exercise)
        }
    }
    
    
    /// 查找一个连线题，有可能是备选题
    /// - Parameters:
    ///   - step:
    ///   - type:
    func _findConnectionExercise(exercise: YXExerciseModel) -> YXExerciseModel? {
        var connectionExercises = turnDao.selectExercise(type: exercise.type, step: exercise.step, size: 4)
        
        // 填充word
        connectionExercises = _fillConnectionWordModel(exercises: connectionExercises)
        
        // 连线题中，是否有单词拼写相同的，如果有都用备选题
        let sameWords = _sameWordArray(connectionArray: connectionExercises)
        
        // 有相同拼写，或者连线只有一个，都用备选题
        if sameWords.count > 0 || connectionExercises.count == 1 {
            let e = connectionExercises.first
            if var backupExercise = turnDao.selectBackupExercise(exerciseId: e?.eid ?? 0, step: e?.step ?? 0) {
                backupExercise.word = _selectWord(wordId: backupExercise.wordId)
                return processExerciseOption(exercise: backupExercise)
            } else {
                YXLog("备选题为空， 出错")
                return nil
            }
        }
        
        // 正常出连线题
        if connectionExercises.count > 1 {
            return processConnectionExerciseOption(exercises: connectionExercises)
        }
        return nil
    }
    
    
    func _sameWordArray(connectionArray: [YXExerciseModel]) -> [Int] {
        var ids: [Int] = []
        for exercise in connectionArray {
            for e in connectionArray {
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
    
    
    func _fillConnectionWordModel(exercises: [YXExerciseModel]) -> [YXExerciseModel] {
        var es: [YXExerciseModel] = []
        for e in exercises {
            var model = e
            model.word = _selectWord(wordId: e.wordId)
            es.append(model)
        }
        return es
    }
    
    
    func _selectWord(wordId: Int) -> YXWordModel? {
        if learnConfig.learnType == .base {
            return wordDao.selectWord(bookId: learnConfig.bookId, wordId: wordId)
        } else {
            return wordDao.selectWord(wordId: wordId)
        }
    }
    
}
