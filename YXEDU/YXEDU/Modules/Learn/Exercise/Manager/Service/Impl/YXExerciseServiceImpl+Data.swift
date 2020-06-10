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
    func _processData(competion: (() -> Void)?) {
        if (_resultModel?.newWordIds?.count == .some(0) && _resultModel?.groups.count == .some(0)) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(learnConfig.learnType)")
            progress = .empty
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
        self.learnConfig.bookId = _resultModel?.bookId ?? 0
        self.learnConfig.unitId = _resultModel?.unitId ?? 0
        
        
        // 插入练习数据【新学/复习】
        self._processExercise(wordIds: _resultModel?.newWordIds ?? [], isNew: true, recordId: recordId)
        self._processExercise(wordIds: _resultModel?.reviewWordIds ?? [], isNew: false, recordId: recordId)
        
        // 插入单词步骤数据【新学/训练/复习】
        self._processWordStep(recordId: recordId)
        
        // 加载答题选项
        self._loadExerciseOption()

        competion?()
    }
    
    
    /// 处理学习记录
    func _processStudyRecord() -> Int {
        guard let group = _resultModel?.groups.first, group.count > 0 else {
            YXLog("学习数据异常，无法查找第一组初始最小 Turn")
            return 0
        }
        
        // 正常情况下取首个step的下标，有可能服务端数据异常，前面的step是空数组，还是遍历查找 s0到s4中，起始step是哪个
        var currentMinStep = 0
        for step in group {
            if step.count == 0 {
                continue
            }
            currentMinStep = step.first?.step ?? 0
            break
        }
        
        // 设置初始轮下标，需要减1，因为筛选数据的时候，做了+1处理
        let startTurn = currentMinStep - 1
        
        return self.studyDao.insertStudyRecord(learn: learnConfig, type: ruleType, turn: startTurn)
    }
    
    
    /// 练习数据
    /// - Parameter result: 网络数据
    func _processExercise(wordIds: [Int], isNew: Bool, recordId: Int) {
        YXLog("\n插入数据 is_new= \(isNew ) ====== 开始")
        // 处理单词列表
        for wordId in wordIds {
            var word = YXWordModel()
            word.wordId = wordId
            word.bookId = learnConfig.bookId
            word.unitId = learnConfig.unitId

            var exercise = YXExerciseModel()
            exercise.learnType = learnConfig.learnType
            exercise.word      = word
            exercise.isNewWord = isNew
            exercise.unfinishStepCount = _unfinishStepCount(wordId: wordId)
            
            // 插入练习数据
            let exerciseId = exerciseDao.insertExercise(learn: learnConfig, rule: ruleType, study: recordId, exerciseModel: exercise)

            // 映射单词ID和表ID
            self._wordIdMap[wordId] = exerciseId

            YXLog("插入练习数据—— 是否新学：\(isNew) ，单词ID：", word.wordId ?? 0, exerciseId > 0 ? "成功" : "失败")
        }
    }
    
    
    /// 处理训练和复习步骤
    /// - Parameter result:
    func _processWordStep(recordId: Int) {
        YXLog("\n插入步骤数据====== 开始")
        guard let groups = _resultModel?.groups else {
            return
        }
        for (index, group) in groups.enumerated() {
            for step in group {
                for subStep in step {
                    if _isConnectionType(model: subStep) {
                        var exercise = subStep
                        for item in subStep.option?.firstItems ?? [] {
                            // 连线题，wordId没有，需要构造一个
                            exercise.wordId = item.optionId
                            _addWordStep(subStep: exercise, recordId: recordId, group: index)
                        }
                    } else {
                        _addWordStep(subStep: subStep, recordId: recordId, group: index)
                    }
                }
            }
        }
        
        YXLog("\n插入步骤数据====== 结束")
    }

    
    func _addWordStep(subStep: YXExerciseModel, recordId: Int, group: Int) {
        
        var word = YXWordModel()
        word.wordId = subStep.wordId
        
        // 如果不是基础学习类型，bookId和unitId是虚拟的
        word.bookId = learnConfig.bookId
        word.unitId = learnConfig.unitId
        
        var exercise = subStep
        exercise.learnType = learnConfig.learnType
        exercise.word = word
        exercise.group = group
        exercise.eid = _wordIdMap[exercise.wordId] ?? 0

        let result = stepDao.insertWordStep(study: recordId, exerciseModel: exercise)
        YXLog("插入 Group:\(group) \(_stepString(exercise)) 数据, wordId:", subStep.wordId, result ? "成功" : "失败")
    }
    
    
    
    func _isConnectionType(model: YXExerciseModel) -> Bool {
        return model.type == .connectionWordAndChinese || model.type == .connectionWordAndImage
    }

    
    func _stepScoreRule() -> Int {
        return 0
    }
    
    
    func _stepString(_ exercise: YXExerciseModel) -> String {
        if exercise.step == 0 {
            return "新学step:\(exercise.step)"
        } else if exercise.isNewWord {
            return "训练step:\(exercise.step)"
        } else {
            return "复习step:\(exercise.step)"
        }
    }
    
    
    func _unfinishStepCount(wordId: Int) -> Int {
        var count = 0
        for group in _resultModel?.groups ?? [] {
            for step in group {
                for subStep in step {
                    if subStep.wordId == wordId {
                        count += 1
                        break;
                    }
                }
            }
        }
        return count
    }
}

