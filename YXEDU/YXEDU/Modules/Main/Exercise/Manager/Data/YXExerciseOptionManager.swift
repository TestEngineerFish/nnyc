//
//  YXExerciseOptionManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXExerciseOptionManager: NSObject {
    
    
    private var newWordArray: [YXWordExerciseModel] = []
    private var reviewWordArray: [YXWordExerciseModel] = []

    
    /// 随机数
    /// - Parameter max: 最大数，不包括这个数
    func random(max: Int) -> Int {
        if max == 0 {
            return 0
        }
        return Int(arc4random()) % max
    }
    

    
    func processOptions(newArray: [YXWordExerciseModel], reviewArray: [YXWordExerciseModel]) -> [YXWordExerciseModel] {
        newWordArray = newArray
        reviewWordArray = reviewArray
        
        self.processReviewWordOption()
        return reviewWordArray
    }
    
    func processReviewWordOption() {
        
        
        for (index, exercise) in reviewWordArray.enumerated() {
            switch exercise.type {
            case .lookWordChooseImage, .lookExampleChooseImage, .lookWordChooseChinese,
                 .lookExampleChooseChinese, .lookChineseChooseWord, .lookImageChooseWord,
                 .listenChooseWord, .listenChooseChinese, .listenChooseImage:
                reviewWordOption(index: index)
            case .validationImageAndWord, .validationWordAndChinese:
                validReviewWordOption(index: index)
            default:
                print("其他题型不用生成选项")
            }

        }
    }
    
        
    func reviewWordOption(index: Int)  {
        
        var exerciseModel = reviewWordArray[index]
        
        var items: [YXOptionItemModel] = []

        // 其他的新学单词集合，排除当前的单词
        let wordArray = self.otherWordArray(wordId: exerciseModel.word?.wordId ?? 0)
        let itemCount = wordArray.count >= 3 ? 3 : wordArray.count
        for _ in 0..<itemCount {
            let e = wordArray[random(max: wordArray.count)]
            items.append(itemModel(word: e.word!, type: exerciseModel.type))
        }
        
        // 选项不够4个，从当前学习流程中随机取
        if items.count < 3 {
            var isOK = true
            
            // 查询的次数还有问题，后续需要优化
            var selectCount = 0
            let max = self.reviewWordArray.count
            while max > 0 && isOK  {
                
                let reviewExercise = reviewWordArray[random(max: max)]
                if reviewExercise.word?.wordId != exerciseModel.word?.wordId {
                    items.append(itemModel(word: reviewExercise.word!, type: exerciseModel.type))
                    if items.count == 3 {
                        isOK = false
                    }
                }
                selectCount += 1
                if selectCount > 5 {
                    isOK = false
                }
            }
        }
                        
//        if items.count < 3 {
//            var isOK = true
//            var selectCount = 0
//            while isOK  {
//                let currentUnitWordArray = self.currentUnitWordArray(unit: exerciseModel.word?.unitId ?? 0)
//                let unitWord = currentUnitWordArray[random(max: currentUnitWordArray.count)]
//                if unitWord.wordId != exerciseModel.word?.wordId {
//                    items.append(itemModel(word: unitWord, type: exerciseModel.type))
//                    if items.count == 3 {
//                        isOK = false
//                    }
//                }
//                selectCount += 1
//                if selectCount > 5 {
//                    isOK = false
//                }
//            }
//        }
    
        
        // 添加正取的选项
        let at = random(max: items.count + 1)
        items.insert(itemModel(word: exerciseModel.word!, type: exerciseModel.type), at: at)
        
        var option = YXExerciseOptionModel()
        option.firstItems = items
        
        exerciseModel.option = option
        exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
        
        reviewWordArray[index] = exerciseModel
    }
    
    
    func validReviewWordOption(index: Int)  {
        var exerciseModel = reviewWordArray[index]
        
//        exerciseModel.question?.soundmark = exerciseModel.word?.soundmark
        var items: [YXOptionItemModel] = []
        
        let max = self.reviewWordArray.count
        let num = self.random(max: max)
        if num % 2 == 1 {// 对
            exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
            exerciseModel.question?.meaning = exerciseModel.word?.meaning
            
                                        
            var item = YXOptionItemModel()
            item.optionId = -1
            
            items.append(itemModel(word: exerciseModel.word!, type: exerciseModel.type))
            items.append(item)
        } else {// 错
            // 其他的新学单词集合，排除当前的单词
            var wordArray = self.otherWordArray(wordId: exerciseModel.word?.wordId ?? 0)
            if wordArray.count == 0 {
                wordArray = reviewWordArray
            }
            
            let exercise = wordArray[random(max: wordArray.count)]
            exerciseModel.question?.meaning = exercise.word?.meaning
            
            
            var item = YXOptionItemModel()
            item.optionId = -1
                        
            items.append(item)
            items.append(itemModel(word: exerciseModel.word!, type: exerciseModel.type))
        }

        var option = YXExerciseOptionModel()
        option.firstItems = items
        
        exerciseModel.option = option
        exerciseModel.answers = [exerciseModel.word?.wordId ?? 0]
        
        reviewWordArray[index] = exerciseModel
    }
    
    /// 其他新学单词
    /// - Parameter index: 需要排除的
    func otherWordArray(wordId: Int) ->  [YXWordExerciseModel] {
        var array: [YXWordExerciseModel] = []
        for exercise in newWordArray {
            if exercise.word?.wordId == wordId {
                continue
            }
            array.append(exercise)
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
            default:
            print()
        }
        
        return item
    }
    
}
