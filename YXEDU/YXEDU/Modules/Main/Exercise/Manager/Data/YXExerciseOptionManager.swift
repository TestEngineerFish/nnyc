//
//  YXExerciseOptionManager2.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/26.
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
        return Int.random(in: 0..<max)
    }
    

    func initData(newArray: [YXWordExerciseModel], reviewArray: [YXWordExerciseModel]) {
        self.newWordArray = newArray
        self.reviewWordArray = reviewArray
    }
    
    func processReviewWordOption(exercise: YXWordExerciseModel) -> YXWordExerciseModel? {
        
        switch exercise.type {
        case .lookWordChooseImage, .lookExampleChooseImage, .listenChooseImage:
            return reviewWordOption(exercise: exercise)
        case .lookWordChooseChinese,
        .lookExampleChooseChinese, .lookChineseChooseWord, .lookImageChooseWord,
        .listenChooseWord, .listenChooseChinese:
            return reviewWordOption(exercise: exercise, isFilterNilImage: false)
        case .validationImageAndWord, .validationWordAndChinese:

            return validReviewWordOption(exercise: exercise)
        default:

            print("其他题型不用生成选项")
            return exercise
        }
    }

    /// 默认过滤没有图片的单词
    func reviewWordOption(exercise: YXWordExerciseModel, isFilterNilImage: Bool = true)  -> YXWordExerciseModel? {
        // 选项个数
        let itemCount = exercise.question?.itemCount ?? 4
        
        var exerciseModel = exercise
        var items         = [YXOptionItemModel]()
        // 提高查找速度,拿空间换时间
        var whiteList = [String?]()

        guard let wordModel = exerciseModel.word, let currentWordId = exerciseModel.word?.wordId else {
            return nil
        }
        // 从新学单词获取数据
        whiteList.append(wordModel.word)
        let otherNewWordArray = self.otherNewWordArray(wordId: currentWordId)
        var tmpOtherNewWordArray = otherNewWordArray
        for _ in otherNewWordArray {
            let randomInt = Int.random(in: 0..<tmpOtherNewWordArray.count)
            let _wordExerciseModel = tmpOtherNewWordArray[randomInt]
            guard let wordModel = _wordExerciseModel.word else {
                continue
            }
            if isFilterNilImage && (wordModel.imageUrl?.isEmpty ?? true) {
                continue
            }
            let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
            items.append(itemModel)
            whiteList.append(wordModel.word)
            tmpOtherNewWordArray.remove(at: randomInt)
            if items.count > itemCount - 2 {
                break
            }
        }
        
        // 从学习流程获取数据
        if items.count < itemCount - 1 {
            // 防止无限随机同一个对象
            var tmpReviewWordArray = reviewWordArray
            for _ in 0..<reviewWordArray.count {
                let randomInt = Int.random(in: 0..<tmpReviewWordArray.count)
                let _wordExerciseModel = tmpReviewWordArray[randomInt]
                guard let wordModel = _wordExerciseModel.word else {
                    continue
                }
                if isFilterNilImage && (wordModel.imageUrl?.isEmpty ?? true) {
                    continue
                }
                if !whiteList.contains(wordModel.word) {
                    let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                    items.append(itemModel)
                }
                whiteList.append(wordModel.word)
                // 移除已经随机过的对象
                tmpReviewWordArray.remove(at: randomInt)
                if items.count > itemCount - 2 {
                    break
                }
            }
        }
        // 从单元词书获取数据
        if items.count < itemCount - 1 {
            if let unitId = exerciseModel.word?.unitId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByUnitId(unitId: unitId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let wordModel = tmpWordModelArray[randomInt]
                    if isFilterNilImage && (wordModel.imageUrl?.isEmpty ?? true) {
                        continue
                    }
                    if !whiteList.contains(wordModel.word) {
                        let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                        items.append(itemModel)
                    }
                    whiteList.append(wordModel.word)
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count > itemCount - 2 {
                        break
                    }
                }
            }
        }
        // 从书中获取数据
        if items.count < itemCount - 1 {
            if let bookId = exerciseModel.word?.bookId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByBookId(bookId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let wordModel = tmpWordModelArray[randomInt]
                    if isFilterNilImage && (wordModel.imageUrl?.isEmpty ?? true) {
                        continue
                    }
                    if !whiteList.contains(wordModel.word) {
                        let itemModel = self.itemModel(word: wordModel, type: exerciseModel.type)
                        items.append(itemModel)
                    }
                    whiteList.append(wordModel.word)
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count > itemCount - 2 {
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
        
        //        reviewWordArray[index] = exerciseModel
        return exerciseModel
    }
    
    
    func validReviewWordOption(exercise: YXWordExerciseModel) -> YXWordExerciseModel? {
        let wordId = exercise.word?.wordId ?? 0
        var exerciseModel = exercise
        
        print("正确:", exercise.word?.wordId, exercise.word?.word, exercise.word?.meaning, exercise.word?.imageUrl)
        //        exerciseModel.question?.soundmark = exerciseModel.word?.soundmark
        var items: [YXOptionItemModel] = []
        
        let max = self.reviewWordArray.count
        let num = self.random(max: max)
        if num % 2 == 1 {// 对
            exerciseModel.answers = [wordId]
            
            var item = YXOptionItemModel()
            item.optionId = -1
            
            items.append(itemModel(word: exerciseModel.word!, type: exerciseModel.type))
            items.append(item)
        } else {// 错
            // 其他的新学单词集合，排除当前的单词
            var wordArray = self.otherNewWordArray(wordId: exerciseModel.word?.wordId ?? 0)
            
            var tmpWord: YXWordModel?
            if wordArray.count == 0, let wordModel = exerciseModel.word {
                wordArray = self.otherReviewWordArray(wordId: wordModel.wordId ?? 0)
                if wordArray.isEmpty {
                    if let otherWordModel = self.otherWordExampleModel(wordModel: wordModel){
                        tmpWord = otherWordModel
                    }
                } else {
                    let wordExerciseModel = wordArray.randomElement()
                    tmpWord = wordExerciseModel?.word
                }
            } else {
                let wordExerciseModel = wordArray.randomElement()
                tmpWord = wordExerciseModel?.word
            }
            
            var item = YXOptionItemModel()
            item.optionId = -1

            items.append(item)
            items.append(itemModel(replace: false, word: tmpWord!, type: exerciseModel.type))
            
            print("错误1:\(tmpWord?.wordId), \(tmpWord?.word), \(tmpWord?.meaning), \(tmpWord?.imageUrl)")
            print("错误2:\(exerciseModel.word?.wordId), \(exerciseModel.word?.word), \(exerciseModel.word?.meaning), \(exerciseModel.word?.imageUrl)")
            
            exerciseModel.answers = [tmpWord?.wordId ?? 0]
        }

        var option = YXExerciseOptionModel()
        option.firstItems = items
        
        exerciseModel.option = option
        
        
        return exerciseModel
    }
    
    
    public func connectionExercise(exerciseArray: [YXWordExerciseModel]) -> YXWordExerciseModel {

        var exercise = exerciseArray.first!
        var option = YXExerciseOptionModel()

        option.firstItems = []
        option.secondItems = []

        for e in exerciseArray {
            var item = YXOptionItemModel()
            item.optionId = e.word?.wordId ?? 0
            item.content = e.word?.word
            option.firstItems?.append(item)


            var rightItem = YXOptionItemModel()
            rightItem.optionId = e.word?.wordId ?? 0

            if exercise.type == .connectionWordAndImage {
                rightItem.content = e.word?.imageUrl
            } else if exercise.type == .connectionWordAndChinese {
                rightItem.content = e.word?.meaning
            }


            option.secondItems?.append(rightItem)
        }

        option.secondItems = option.secondItems?.shuffled()

        exercise.option = option

        return exercise
    }
    
    
    /// 其他新学单词
    /// - Parameter index: 需要排除的
    func otherNewWordArray(wordId: Int) ->  [YXWordExerciseModel] {
        let array = self.newWordArray.filter { (wordModel) -> Bool in
            return wordModel.word?.wordId != wordId
        }
        return array
    }
    
    
    func otherReviewWordArray(wordId: Int) ->  [YXWordExerciseModel] {
        let array = self.reviewWordArray.filter { (wordModel) -> Bool in
            return wordModel.word?.wordId != wordId
        }
        return array
    }

    /// 获取一个其他单词选项
    func otherWordExampleModel(wordModel: YXWordModel, isFilterNilImage: Bool = true) -> YXWordModel? {
        
        // 从单元词书获取数据
        if let unitId = wordModel.unitId {
            let wordModelArray = YXWordBookDaoImpl().selectWordByUnitId(unitId: unitId)
            let tmpWordModelArray = wordModelArray
            for _ in 0..<wordModelArray.count {
                let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                let otherWordModel = tmpWordModelArray[randomInt]
                if isFilterNilImage && (otherWordModel.imageUrl?.isEmpty ?? true) {
                    continue
                }
                if otherWordModel.word != wordModel.word {
                    return otherWordModel
                }
            }
        }
        // 从书中获取数据
        if let bookId = wordModel.bookId {
            let wordModelArray = YXWordBookDaoImpl().selectWordByBookId(bookId)
            let tmpWordModelArray = wordModelArray
            for _ in 0..<wordModelArray.count {
                let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                let otherWordModel = tmpWordModelArray[randomInt]
                if isFilterNilImage && (otherWordModel.imageUrl?.isEmpty ?? true) {
                    continue
                }
                if otherWordModel.word != wordModel.word {
                    return otherWordModel
                }
            }
        }
        return nil
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
    
    
    /// 构造选项
    /// - Parameters:
    ///   - replace: 判断题使用，不能把错的选项用对的覆盖了
    ///   - word:
    ///   - type:
    func itemModel(replace: Bool = true, word: YXWordModel, type: YXExerciseType) -> YXOptionItemModel {
        var item = YXOptionItemModel()
        item.optionId = word.wordId ?? -1
        
        var newWord = word
        // 为什么要查询一次，因为出题后，数据缓存了，后面更新了词书，没有使用最新的，需要时时查询，后续要优化
        if replace, let w = YXWordBookDaoImpl().selectWord(wordId: item.optionId) {
            newWord = w
        }
        
        switch type {
        case .lookWordChooseImage:
            item.content = newWord.imageUrl
        case .lookExampleChooseImage:
            item.content = newWord.imageUrl
        case .lookWordChooseChinese:
            item.content = newWord.meaning
        case .lookExampleChooseChinese:
            item.content = newWord.meaning
        case .lookChineseChooseWord:
            item.content = newWord.word
        case .lookImageChooseWord:
            item.content = newWord.word
        case .listenChooseWord:
            item.content = newWord.word
        case .listenChooseChinese:
            item.content = newWord.meaning
        case .listenChooseImage:
            item.content = newWord.imageUrl
        case .validationImageAndWord:
            item.content = newWord.imageUrl
        case .validationWordAndChinese:
            item.content = (newWord.partOfSpeech ?? "") + " " + (newWord.meaning ?? "")
        default:
            break
        }
        
        return item
    }
    
    
    
}
