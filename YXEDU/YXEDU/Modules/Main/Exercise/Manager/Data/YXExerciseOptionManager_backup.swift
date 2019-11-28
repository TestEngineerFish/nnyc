//
//  YXExerciseOptionManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXExerciseOptionManager_backup: NSObject {
    
    
    private var newWordArray: [YXWordExerciseModel] = []
    private var reviewWordArray: [[YXWordExerciseModel]] = []
    
    /// 所有复习题的1维数组
    private var exerciseArray: [YXWordExerciseModel] = []
    
    /// 随机数
    /// - Parameter max: 最大数，不包括这个数
    func random(max: Int) -> Int {
        if max == 0 {
            return 0
        }
        return Int.random(in: 0..<max)
    }
    

    func processOptions(newArray: [YXWordExerciseModel], reviewArray: [[YXWordExerciseModel]]) -> [[YXWordExerciseModel]] {
        self.newWordArray = newArray
        self.reviewWordArray = reviewArray
        
        self.exerciseArray.removeAll()
        for subArray in reviewWordArray {
            for e in subArray {
                self.exerciseArray.append(e)
            }
        }
        
        self.processReviewWordOption()
        return self.reviewWordArray
    }
    
    func processReviewWordOption() {
        
        for (step, subArray) in reviewWordArray.enumerated() {
            for (index, exercise) in subArray.enumerated() {
                switch exercise.type {
                case .lookWordChooseImage, .lookExampleChooseImage, .lookWordChooseChinese,
                     .lookExampleChooseChinese, .lookChineseChooseWord, .lookImageChooseWord,
                     .listenChooseWord, .listenChooseChinese, .listenChooseImage:
                    reviewWordOption(step: step, index: index)
                case .validationImageAndWord, .validationWordAndChinese:
                    validReviewWordOption(step: step, index: index)
                default:
                    print("其他题型不用生成选项")
                }

            }
        }
        
    }

    func reviewWordOption(step: Int, index: Int)  {

        var exerciseModel = reviewWordArray[step][index]
        var items         = [YXOptionItemModel]()
        // 提高查找速度,拿空间换时间
        var whiteList = [Int?]()

        guard let currentWordId = exerciseModel.word?.wordId else {
            return
        }
        // 从新学单词获取数据
        whiteList.append(currentWordId)
        let otherNewWordArray = self.otherNewWordArray(wordId: currentWordId)
        for _wordExerciseModel in otherNewWordArray {
            guard let wordModel = _wordExerciseModel.word else {
                continue
            }
            let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
            items.append(itemModel)
            whiteList.append(wordModel.wordId)
            if items.count > 2 {
                break
            }
        }

        // 从学习流程获取数据
        if items.count < 3 {
            // 防止无限随机同一个对象
            var tmpReviewWordArray = exerciseArray
            for _ in 0..<exerciseArray.count {
                let randomInt = Int.random(in: 0..<tmpReviewWordArray.count)
                let _wordExerciseModel = tmpReviewWordArray[randomInt]
                guard let wordModel = _wordExerciseModel.word else {
                    continue
                }
                if !whiteList.contains(wordModel.wordId) {
                    let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                    items.append(itemModel)
                }
                whiteList.append(wordModel.wordId)
                // 移除已经随机过的对象
                tmpReviewWordArray.remove(at: randomInt)
                if items.count > 2 {
                    break
                }
            }
        }
        // 从单元词书获取数据
        if items.count < 3 {
            if let unitId = exerciseModel.word?.unitId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByUnitId(unitId: unitId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let wordModel = tmpWordModelArray[randomInt]
                    if !whiteList.contains(wordModel.wordId) {
                        let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                        items.append(itemModel)
                    }
                    whiteList.append(wordModel.wordId)
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count > 2 {
                        break
                    }
                }
            }
        }
        // 从书中获取数据
        if items.count < 3 {
            if let bookId = exerciseModel.word?.bookId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByBookId(bookId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let wordModel = tmpWordModelArray[randomInt]
                    if !whiteList.contains(wordModel.wordId) {
                        let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                        items.append(itemModel)
                    }
                    whiteList.append(wordModel.wordId)
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count > 2 {
                        break
                    }
                }
            }
        }
        
        // 添加正取的选项
        let at = random(max: items.count + 1)
        items.insert(itemModel(word: exerciseModel.word!, type: exerciseModel.type), at: at)
        
        var option = YXExerciseOptionModel()
        option.firstItems = items
        
        exerciseModel.option = option
        exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
        
        reviewWordArray[step][index] = exerciseModel
    }
    
    
    func validReviewWordOption(step: Int, index: Int)  {
        var exerciseModel = reviewWordArray[step][index]
        
//        exerciseModel.question?.soundmark = exerciseModel.word?.soundmark
        var items: [YXOptionItemModel] = []
        
        let max = self.reviewWordArray.count
        let num = self.random(max: max)
        if num % 2 == 1 {// 对
            exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
            exerciseModel.question?.meaning = exerciseModel.word?.meaning
            exerciseModel.question?.imageUrl = exerciseModel.word?.imageUrl
                                        
            var item = YXOptionItemModel()
            item.optionId = -1
            
            items.append(itemModel(word: exerciseModel.word!, type: exerciseModel.type))
            items.append(item)
        } else {// 错
            // 其他的新学单词集合，排除当前的单词
            var wordArray = self.otherNewWordArray(wordId: exerciseModel.word?.wordId ?? 0)
            if wordArray.count == 0 {
                wordArray = exerciseArray
            }
            
            let exercise = wordArray[random(max: wordArray.count)]
            exerciseModel.question?.meaning = exercise.word?.meaning
            exerciseModel.question?.imageUrl = exercise.word?.imageUrl
            
            var item = YXOptionItemModel()
            item.optionId = -1
                        
            items.append(item)
            items.append(itemModel(word: exerciseModel.word!, type: exerciseModel.type))
        }

        var option = YXExerciseOptionModel()
        option.firstItems = items
        
        exerciseModel.option = option
        exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
        
        reviewWordArray[step][index] = exerciseModel
    }
    
    /// 其他新学单词
    /// - Parameter index: 需要排除的
    func otherNewWordArray(wordId: Int) ->  [YXWordExerciseModel] {
        let array = self.newWordArray.filter { (wordModel) -> Bool in
            return wordModel.word?.wordId != wordId
        }
        return array
    }
    
    
    /// 当前单元的单词
    /// - Parameter unit:
    func currentUnitWordArray(unit: Int) ->[YXWordModel] {
        
//        var array: [YXWordExerciseModel] = []
//        for exercise in reviewWordArray {
//            array.append(exercise)
//        }
        return []
    }
    
    
    func itemModel(word: YXWordModel, type: YXExerciseType) -> YXOptionItemModel {
        var item = YXOptionItemModel()
        item.optionId = word.wordId ?? -1
        
        switch type {
            case .lookWordChooseImage:
                item.content = word.imageUrl
            case .lookExampleChooseImage:
                item.content = word.imageUrl
            case .lookWordChooseChinese:
                item.content = word.meaning
            case .lookExampleChooseChinese:
                item.content = word.meaning
            case .lookChineseChooseWord:
                item.content = word.word
            case .lookImageChooseWord:
                item.content = word.word
            case .listenChooseWord:
                item.content = word.word
            case .listenChooseChinese:
                item.content = word.meaning
            case .listenChooseImage:
                item.content = word.imageUrl
            default:
                break
        }
        
        return item
    }
    
}
