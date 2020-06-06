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

    
    /*
     // 当前轮是否做完
     var isFinished = true
     for e in currentTurnArray {
         if !e.isCurrentTurnFinish {
             isFinished = false
         }
     }

     if isFinished {
         currentTurnIndex += 1
         // 清空当前轮已做完的数据
         self.currentTurnArray.removeAll()
         // 如果是主流程，则需要添加训练题
         if dataType == .base {
             filterExcercise()
         }
         filterReview()
         
         removeErrorStep()
         // 排序
         self.sortCurrentTurn()
     }
     */
    func _filterExercise() {
        // 当前轮是否做完
        if turnDao.selectTurnFinishStatus() {
            //更新轮下标
            studyDao.updateCurrentTurn(learn: learnConfig, turn: nil)
            
            // 清空当前轮
            turnDao.deleteCurrentTurn()
            
            // 插入新的轮
            turnDao.insertCurrentTurn()
        }
    }
    
    
    func _findExercise() -> YXExerciseModel? {
        guard let exericse = turnDao.selectExercise() else {
            return nil
        }
        
        // 有连线题
        if exericse.type == .connectionWordAndImage || exericse.type == .connectionWordAndChinese {
            return _findExercise(step: exericse.step, type: exericse.type)
        } else {// 正常返回连线
            return processExerciseOption(exercise: exericse)
        }
    }
    
    
    func _findExercise(step: Int, type: YXQuestionType) -> YXExerciseModel? {
        let exercises = turnDao.selectExercise(step: step, type: type)
        
        // 连线题中，是否有单词拼写相同的，如果有都用备选题
        let sameWordIds = sameWordIdArray(connectionArray: exercises)
        
        // 有相同拼写，或者连线只有一个，都用备选题
        if sameWordIds.count > 0 || exercises.count == 1 {
            let e = exercises.first
            if let backupExercise = turnDao.selectBackupExercise(exerciseId: e?.eid ?? 0, step: e?.step ?? 0) {
                return processExerciseOption(exercise: backupExercise)
            } else {
                YXLog("备选题为空， 出错")
                return nil
            }
        }
        
        // 正常出连线题
        if exercises.count > 1 {
            return processConnectionExerciseOption(exercises: exercises)
        }
        return nil
    }
    
    
    func sameWordIdArray(connectionArray: [YXExerciseModel]) -> [Int] {
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
