//
//  YXExerciseOptionManager2.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/26.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXExerciseOptionManager: NSObject {
    
    private var newWordArray: [YXWordModel]    = []
    private var reviewWordArray: [YXWordModel] = []
    
    /// 随机数
    /// - Parameter max: 最大数，不包括这个数
    func random(max: Int) -> Int {
        if max == 0 {
            return 0
        }
        return Int.random(in: 0..<max)
    }
    

    func initOption(newArray: [YXWordModel], reviewArray: [YXWordModel]) {
        self.newWordArray    = newArray
        self.reviewWordArray = reviewArray
    }
    
    func processReviewWordOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        // 判断题
        let vaildationArray: [YXQuestionType] = [.validationImageAndWord, .validationWordAndChinese]
        // 选择题
        let chooseArray: [YXQuestionType] = [.lookWordChooseImage, .lookExampleChooseImage, .listenChooseImage, .lookWordChooseChinese, .lookExampleChooseChinese, .lookChineseChooseWord, .lookImageChooseWord, .listenChooseWord, .listenChooseChinese]
        if vaildationArray.contains(exercise.type) {
            return validReviewWordOption(exercise: exercise)
        } else if chooseArray.contains(exercise.type) {
            return reviewWordOption(exerciseModel: exercise)
        } else {
            YXLog("其他题型不用生成选项")
            return exercise
        }
    }

    private func reviewWordOption(exerciseModel: YXExerciseModel)  -> YXExerciseModel? {
        guard let wordModel = exerciseModel.word else {
            return nil
        }
        // 选项个数
        let itemCount = exerciseModel.question?.extendModel?.optionItemsCount ?? 4

        var _exerciseModel  = exerciseModel
        var items          = self.filterOtherWord(exerciseModel: _exerciseModel, itemCount: itemCount - 1)

        // 添加正取的选项
        let at = random(max: items.count + 1)
        items.insert(itemModel(word: wordModel, type: _exerciseModel.type, dataType: _exerciseModel.learnType), at: at)
        YXLog("选项ID列表\(items)")
        var option = YXExerciseOptionModel()
        option.firstItems = items

        _exerciseModel.option = option
        _exerciseModel.answers = [_exerciseModel.word?.wordId ?? 0]
        return _exerciseModel
    }
    
    /// 获取其他选项
    private func filterOtherWord(exerciseModel: YXExerciseModel, itemCount: Int) -> [YXOptionItemModel] {
        var items = [YXOptionItemModel]()
        guard let wordModel = exerciseModel.word else {
            return items
        }
        // 提高查找速度,拿空间换时间
        var whiteList = [String?]()
        whiteList.append(wordModel.word)
        // 从【新学、复习】单词列表获取数据
        let otherNewWordArray = self.otherNewWordArray(wordModel: wordModel) + self.otherReviewWordArray(wordModel: wordModel)
        var tmpOtherNewWordArray = otherNewWordArray
        for _ in otherNewWordArray {
            let randomInt = Int.random(in: 0..<tmpOtherNewWordArray.count)
            let otherWordModel = tmpOtherNewWordArray[randomInt]
            // 如果选项单词在题目单词的黑名单中，则不使用
            if YXStepConfigManager.share.onBlockList(exercise: exerciseModel.step, wordId: exerciseModel.word?.wordId, otherWordId: otherWordModel.wordId) {
                continue
            }
            if !whiteList.contains(otherWordModel.word) {
                guard let itemModel = self.filterRepeatWord(exerciseModel: exerciseModel, otherWordModel: otherWordModel) else {
                    continue
                }
                items.append(itemModel)
                whiteList.append(otherWordModel.word)
            }
            // 移除已经随机过的对象
            tmpOtherNewWordArray.remove(at: randomInt)
            if items.count >= itemCount {
                break
            }
        }

        // 从当前词书单元获取数据
        if items.count < itemCount {
            if let unitId = exerciseModel.word?.unitId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByUnitId(unitId: unitId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let otherWordModel = tmpWordModelArray[randomInt]
                    if !whiteList.contains(otherWordModel.word) {
                        guard let itemModel = self.filterRepeatWord(exerciseModel: exerciseModel, otherWordModel: otherWordModel) else {
                            continue
                        }
                        // 如果选项单词在题目单词的黑名单中，则不使用
                        if YXStepConfigManager.share.onBlockList(exercise: exerciseModel.step, wordId: exerciseModel.word?.wordId, otherWordId: otherWordModel.wordId) {
                            continue
                        }
                        items.append(itemModel)
                        whiteList.append(otherWordModel.word)
                    }
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count >= itemCount {
                        break
                    }
                }
            }
        }
        // 从书中获取数据
        if items.count < itemCount {
            if let bookId = exerciseModel.word?.bookId {
                let wordModelArray = YXWordBookDaoImpl().selectWordByBookId(bookId)
                var tmpWordModelArray = wordModelArray
                for _ in 0..<wordModelArray.count {
                    let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                    let otherWordModel = tmpWordModelArray[randomInt]
                    if !whiteList.contains(otherWordModel.word) {
                        guard let itemModel = self.filterRepeatWord(exerciseModel: exerciseModel, otherWordModel: otherWordModel) else {
                            continue
                        }
                        // 如果选项单词在题目单词的黑名单中，则不使用
                        if YXStepConfigManager.share.onBlockList(exercise: exerciseModel.step, wordId: exerciseModel.word?.wordId, otherWordId: otherWordModel.wordId) {
                            continue
                        }
                        items.append(itemModel)
                        whiteList.append(otherWordModel.word)
                    }
                    // 移除已经随机过的对象
                    tmpWordModelArray.remove(at: randomInt)
                    if items.count >= itemCount {
                        break
                    }
                }
            }
        }
        // 从其他书中获取
        if items.count < itemCount {
            if let bookId = exerciseModel.word?.bookId {
                let bookIdList = YXWordBookDaoImpl().selectBookIdList()
                for otherBookId in bookIdList {
                    if otherBookId == bookId {
                       continue
                    }
                    let wordModelArray = YXWordBookDaoImpl().selectWordByBookId(otherBookId)
                    var tmpWordModelArray = wordModelArray
                    for _ in 0..<wordModelArray.count {
                        let randomInt = Int.random(in: 0..<tmpWordModelArray.count)
                        let otherWordModel = tmpWordModelArray[randomInt]
                        if !whiteList.contains(otherWordModel.word) {
                            guard let itemModel = self.filterRepeatWord(exerciseModel: exerciseModel, otherWordModel: otherWordModel) else {
                                continue
                            }
                            // 如果选项单词在题目单词的黑名单中，则不使用
                            if YXStepConfigManager.share.onBlockList(exercise: exerciseModel.step, wordId: exerciseModel.word?.wordId, otherWordId: otherWordModel.wordId) {
                                continue
                            }
                            items.append(itemModel)
                            whiteList.append(otherWordModel.word)
                        }
                        // 移除已经随机过的对象
                        tmpWordModelArray.remove(at: randomInt)
                        if items.count >= itemCount {
                            break
                        }
                    }
                    if items.count >= itemCount {
                        break
                    }
                }
            }
        }
        return items
    }
    
    // TODO: ==== Tools ====
    /// 根据题型过滤数据
    private func filterRepeatWord(exerciseModel: YXExerciseModel, otherWordModel: YXWordModel) -> YXOptionItemModel? {
        guard let rightWordModel = exerciseModel.word else {
            return nil
        }
        switch exerciseModel.type {
        case .lookWordChooseImage, .lookExampleChooseImage, .listenChooseImage, .validationImageAndWord:
            guard let rightImageUrl = rightWordModel.imageUrl, let otherImageUrl = otherWordModel.imageUrl else {
                return nil
            }
            if otherImageUrl == rightImageUrl || otherImageUrl.isEmpty {
                return nil
            }
        case .lookWordChooseChinese,
             .lookExampleChooseChinese, .listenChooseChinese, .validationWordAndChinese:
            guard let rightMeaning = rightWordModel.meaning, let otherMeaning = otherWordModel.meaning else {
                return nil
            }
            if otherMeaning == rightMeaning || otherMeaning.isEmpty {
                return nil
            }
        case .lookChineseChooseWord, .lookImageChooseWord,
        .listenChooseWord:
            guard let rightWord = rightWordModel.word, let otherWord = otherWordModel.word else {
                return nil
            }
            if rightWord == otherWord || otherWord.isEmpty {
                return nil
            }
        default:
            YXLog("其他题型不用生成选项")
            return nil
        }
        let itemModel = self.itemModel(word: otherWordModel, type: exerciseModel.type, dataType: exerciseModel.learnType)
        return itemModel
    }
    
    
    func validReviewWordOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        guard let wordModel = exercise.word else {
            return exercise
        }
        let wordId = exercise.word?.wordId ?? 0
        var exerciseModel = exercise
        
        var items: [YXOptionItemModel] = []
        
        let num = self.random(max: 2)
        if num % 2 == 1 {// 对
            exerciseModel.answers = [wordId]
            
            var item = YXOptionItemModel()
            item.optionId = -1
            
            items.append(itemModel(word: wordModel, type: exerciseModel.type, dataType: exerciseModel.learnType))
            items.append(item)
        } else {// 错
            let rightItemArray = self.filterOtherWord(exerciseModel: exerciseModel, itemCount: 1)
            
            var item = YXOptionItemModel()
            item.optionId = -1

            items.append(item)
            if let rightItem = rightItemArray.first {
                items.append(rightItem)
                exerciseModel.answers = [rightItem.optionId]
            }
        }

        var option = YXExerciseOptionModel()
        option.firstItems    = items
        exerciseModel.option = option
        return exerciseModel
    }
    
    /// 其他新学单词
    /// - Parameter index: 需要排除的
    func otherNewWordArray(wordModel: YXWordModel?, isCompareImage: Bool = false) -> [YXWordModel] {
        var wordModelList = [YXWordModel]()
        guard let wordModel = wordModel else {
            return wordModelList
        }
        wordModelList = self.newWordArray.filter { (_wordModel) -> Bool in
            if isCompareImage {
                return _wordModel.word != wordModel.word
                    && _wordModel.imageUrl != wordModel.imageUrl
            }
            return _wordModel.word != wordModel.word
        }
        return wordModelList
    }
    
    func otherReviewWordArray(wordModel: YXWordModel?, isCompareImage: Bool = false) ->  [YXWordModel] {
        var wordModelList = [YXWordModel]()
        guard let wordModel = wordModel else {
            return wordModelList
        }
        wordModelList = self.reviewWordArray.filter { (_wordModel) -> Bool in
            if isCompareImage {
                return _wordModel.word != wordModel.word
                    && _wordModel.imageUrl != wordModel.imageUrl
            }
            return _wordModel.word != wordModel.word
        }
        return wordModelList
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
    ///   - word:
    ///   - type:
    func itemModel(word: YXWordModel, type: YXQuestionType, dataType: YXLearnType) -> YXOptionItemModel {
        var item = YXOptionItemModel()
        item.optionId = word.wordId ?? -1
        
        var newWord = word
        // 为什么要查询一次，因为出题后，数据缓存了，后面更新了词书，没有使用最新的，需要时时查询，后续要优化
        if let w = selectWord(bookId: word.bookId ?? 0, wordId: item.optionId, dataType: dataType) {
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
    
    
    func selectWord(bookId: Int, wordId: Int, dataType: YXLearnType) -> YXWordModel? {
        if dataType == .base {
            return YXWordBookDaoImpl().selectWord(bookId: bookId, wordId: wordId)
        } else {
            return YXWordBookDaoImpl().selectWord(wordId: wordId)
        }
    }
}
