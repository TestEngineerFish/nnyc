//
//  YXExerciseDataManager+SkipNewWord.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
    
    /// 设置跳过新学
    func skipNewWord() {
        progressManager.setSkipNewWord()
    }
    
    /// 获取跳过新学状态
    func isSkipNewWord() -> Bool {
         return (progressManager.isSkipNewWord() || ruleType == .p1 || ruleType == .p2)
    }
    
    
    /// 是否显示单词详情页
    /// P2  跳过新学，做题时首次做新学词题目后无论对错必定出现单词详情
    func isShowWordDetail(wordId: Int, step: Int) -> Bool {
        
        var firstStep = 0
        for word in reviewWordArray {
            if word.wordId == wordId {
                for step in word.exerciseSteps {
                    if let e = step.first, let _ = e.word {
                        firstStep = e.step
                        break
                    }
                }
            }
        }
        
        return ruleType == .p2 && firstStep == step
    }
    
    // 新学是否分批
    func isNewWordInBatch() -> Bool {
        return ruleType == .p4 || ruleType == .a1 || ruleType == .a2
    }
    

    
    func newWordBatchSizeConfig() -> Int {
        return ruleType == .a1 || ruleType == .a2 ? 3 : 5
    }
    
    func reviewWordBatchSizeConfig() -> Int {
        return ruleType == .a1 || ruleType == .a2 ? 4 : 5
    }
    
    
    
    
    
}
