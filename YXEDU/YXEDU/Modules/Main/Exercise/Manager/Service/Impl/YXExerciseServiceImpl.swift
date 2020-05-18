//
//  YXExerciseServiceImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseServiceImpl: YXExerciseService {
    
    //MARK: - 属性
    var bookId: Int = 0
    
    var unitId: Int = 0
    
    var dataType: YXExerciseDataType = .base
    
    var ruleType: YXExerciseRuleType { return .p }
    
    var exerciseStatus: YXExerciseStatus { return .learning }
    
//    var isShowWordDetail: Bool { return false }
    
    //MARK: - 方法
    func getExerciseModel() -> YXWordExerciseModel? {
        return nil
    }
    
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool) {
        if exerciseModel.type == .connectionWordAndImage || exerciseModel.type == .connectionWordAndChinese {
            
        } else {
            
        }
    }
    
    func answerAction(exerciseModel: YXWordExerciseModel, right: Bool, optionIndex: Int) {
        
    }
    
    func isShowWordDetail(wordId: Int, step: Int) -> Bool {
        return false
    }
    
    func hasErrorInCurrentTurn(wordId: Int, step: Int) {
        
    }
}
