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
    func _processData(completion: (() -> Void)?) {
        if _resultModel?.wordList.isEmpty == .some(true) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(learnConfig.learnType)")
            progress = .empty
            completion?()
            if let bookModel = self.wordDao.selectBook(bookId: learnConfig.bookId), learnConfig.learnType == .homeworkPunch {
                YXAlertManager().showNoLearningContent(book: bookModel)
            }
            return
        }
        
        // 插入学习记录
        let studyId = self._processStudyRecord()
        if studyId == 0 {
            YXLog("插入学习记录失败")
            return
        }

        // 插入单词数据
        self._processExercise(study: studyId)

        // 更新记录状态
        self.studyDao.updateProgress(study: studyId, progress: .learning)
        
        // 加载答题选项
        self._loadExerciseOption()

        completion?()
    }
    
    /// 处理学习记录
    func _processStudyRecord() -> Int {
        if let model = self.studyDao.selectStudyRecordModel(learn: learnConfig) {
            return model.studyId
        } else {
            return self.studyDao.insertStudyRecord(learn: learnConfig, newWordCount: self._resultModel?.newWordCount ?? 0, reviewWordCount: self._resultModel?.reviewWordCount ?? 0)
        }
    }

    /// 单词和学习步骤数据
    /// - Parameter result: 网络数据
    private func _processExercise(study id: Int) {
        guard let exerciseWordModelList = self._resultModel?.wordList else {
            return
        }
        // 处理单词列表
        for exerciseWordModel in exerciseWordModelList {
            guard let wordModel = exerciseWordModel.wordModel, let wordId = wordModel.wordId else {
                continue
            }
            // 插入练习数据
            let exerciseId = exerciseDao.insertExercise(learn: learnConfig.learnType, study: id, word: wordModel, next: exerciseWordModel.startStep)

            // 插入Step数据
            exerciseWordModel.stepModelList.forEach { (stepModel) in
                stepDao.insertWordStep(studyId: id, exerciseId: exerciseId, wordModel: wordModel, stepModel: stepModel)
            }
            YXLog("插入练习数据，单词ID：", wordId, exerciseId > 0 ? " 成功" : " 失败")
        }
    }
}

