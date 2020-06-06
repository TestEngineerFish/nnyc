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
    
    func queryExerciseModel() -> YXExerciseModel? {
            
        
        return nil
    }

    
    /// 筛选数据
    func _filterExercise() {
        // 当前轮是否做完
        if turnDao.selectTurnFinishStatus() {
            currentTurnIndex += 1
            
            //更新轮下标
            let r1 = studyDao.updateCurrentTurn(learn: learnConfig, turn: currentTurnIndex)
            
            // 清空当前轮
            let r2 = turnDao.deleteCurrentTurn()
                        
            // 插入新的轮
            let studyId = self.studyDao.getStudyID(learn: learnConfig)
            let r3 = turnDao.insertCurrentTurn(studyId: studyId)
            
            YXLog("筛选数据， 更新轮下标", r1, "清空当前轮", r2, "插入新的轮 ,id", studyId, r3)
        }
    }
    
    /// 查找一个练习
    func _findExercise() -> YXExerciseModel? {
        guard let exercise = turnDao.selectExercise() else {
            YXLog("当前轮没有数据了")
            return nil
        }
        // 有连线题
        if isConnectionType(model: exercise) {
            return _findExercise(exercise: exercise)
        } else {// 正常返回连线
            return processExerciseOption(exercise: exercise)
        }
    }
    
    
    /// 查找一个连线题，有可能是备选题
    /// - Parameters:
    ///   - step:
    ///   - type:
    func _findExercise(exercise: YXExerciseModel) -> YXExerciseModel? {
        let connectionExercises = turnDao.selectExercise(type: exercise.type, step: exercise.step)
        
        // 连线题中，是否有单词拼写相同的，如果有都用备选题
        let sameWords = sameWordArray(connectionArray: connectionExercises)
        
        // 有相同拼写，或者连线只有一个，都用备选题
        if sameWords.count > 0 || connectionExercises.count == 1 {
            let e = connectionExercises.first
            if let backupExercise = turnDao.selectBackupExercise(exerciseId: e?.eid ?? 0, step: e?.step ?? 0) {
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
    
    
    func sameWordArray(connectionArray: [YXExerciseModel]) -> [Int] {
        var ids: [Int] = []
        for exercise in connectionArray {
            for e in connectionArray {
                if exercise.word?.wordId == e.word?.wordId {
                    continue
                }
                if exercise.word?.word == e.word?.word {
                    ids.append(exercise.word?.wordId ?? 0)
                }
            }
        }
        
        return ids
    }
    
}
