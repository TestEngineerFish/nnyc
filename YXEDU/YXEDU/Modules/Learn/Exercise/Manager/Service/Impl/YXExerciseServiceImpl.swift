//
//  YXExerciseServiceImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseServiceImpl: YXExerciseService {
    
    // ----------------------------
    //MARK: - 属性
    var learnConfig: YXLearnConfig = YXBaseLearnConfig()
    
    var ruleType: YXExerciseRuleType = .p0
    
    var exerciseProgress: YXExerciseProgress = .reported
    
    // ----------------------------
    //MARK: - Private 属性
    /// 本地数据库访问
    var wordDao: YXWordBookDao = YXWordBookDaoImpl()
    var exerciseDao: YXExerciseDao = YXExerciseDaoImpl()
    var stepDao: YXWordStepDao = YXWordStepDaoImpl()
    
    
    // ----------------------------
    
    //MARK: - 方法
    func fetchExerciseModel() -> YXWordExerciseModel? {
        fetchExerciseResultModels(planId: learnConfig.planId, completion: nil)
        
        self.clearExpiredData()
        self.updateProgress()
        
        return self.queryExerciseModel()
    }
    
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool) {
        if exerciseModel.type == .connectionWordAndImage || exerciseModel.type == .connectionWordAndChinese {
            
        } else {
            
        }
        
        // 答完题后，清理数据
        self.clearExpiredData()
        
        // 更新状态
        self.updateProgress()
    }
    
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool, optionIndex: Int) {
        
        
        
        
    }
    
    func isShowWordDetail(wordId: Int, step: Int) -> Bool {
        return false
    }
    
    func hasErrorInCurrentTurn(wordId: Int, step: Int) {
        
    }
    
    
    // ----------------------------
    //MARK: - Private 方法
    

    
    

}
