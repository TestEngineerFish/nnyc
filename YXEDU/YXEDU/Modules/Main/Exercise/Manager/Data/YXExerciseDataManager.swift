//
//  YXExerciseDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper


/// 练习的数据管理器
class YXExerciseDataManager: NSObject {
    
    private let dao: YXWordBookDao = YXWordBookDaoImpl()
    var exerciseModelArray: [YXWordExerciseModel] = []
    
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchTodayExerciseResultModels(completion: @escaping ((_ result: Bool, _ msg: String?) -> Void)) {
        
        let request = YXExerciseRequest.exercise
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            self.processExerciseData(result: response.data)
            completion(true, nil)
        }) { (error) in
            completion(false, error.message)
        }
    }
    
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchTodayExerciseModels(completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        // --- 测试数据 ----
//        var model = YXWordExerciseModel(.newLearnPrimarySchool)
//        let strArray = ["e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x", "e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x", "e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x"]
//        model.wordArray = strArray
//        let charModelArray: [YXCharacterModel] = {
//            var array = [YXCharacterModel]()
//            var index = 0
//            for str in model.word {
//                let model = YXCharacterModel(str.description, isBlank: index != 0)
//                array.append(model)
//                index += 1
//            }
//            return array
//        }()
//        model.charModelArray = charModelArray
//        // ---- ^^^^^ ----
//        exerciseModelArray = [
//            model,
//            YXWordExerciseModel(.listenChooseWord),
//            YXWordExerciseModel(.listenChooseChinese),
//            YXWordExerciseModel(.listenChooseImage),
//            YXWordExerciseModel(.validationWordAndChinese),
//            YXWordExerciseModel(.validationImageAndWord),
//            YXWordExerciseModel(.lookImageChooseWord),
//            YXWordExerciseModel(.lookChineseChooseWord),
//            YXWordExerciseModel(.lookWordChooseChinese),
//            YXWordExerciseModel(.lookExampleChooseImage),
//            YXWordExerciseModel(.lookWordChooseImage),
//            YXWordExerciseModel(.fillWordAccordingToChinese),
//            YXWordExerciseModel(.lookWordChooseImage),
//            YXWordExerciseModel(.fillWordAccordingToChinese_Connection),
//            YXWordExerciseModel(.lookExampleChooseImage)
//        ]
        completion?(true, nil)
    }
    
    
    
    /// 加载本地未学完的关卡数据
    func fetchUnCompletionExerciseModels() {
        exerciseModelArray = [
//            YXWordExerciseModel(.fillWordAccordingToChinese_Connection),
//            YXWordExerciseModel(.fillWordAccordingToChinese),
//
//            YXWordExerciseModel(.lookWordChooseImage),
//            YXWordExerciseModel(.lookExampleChooseImage)
        ]
    }
    
    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> YXWordExerciseModel? {
        if exerciseModelArray.count == 0 {
            return nil
        }
        return exerciseModelArray.removeFirst()
    }
    
    
    /// 完成一个练习后，答题后删除练习题
    /// - Parameter exerciseModel:
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        

        
        if right {
//            self.exerciseModelArray.removeFirst()
        } else {
            self.addWrongExercise(exerciseModel: exerciseModel)
            self.addWrongBook(exerciseModel: exerciseModel)
        }
    }
    
    /// 错题数据处理，重做
    /// - Parameter wrongExercise: 练习Model
    private func addWrongExercise(exerciseModel: YXWordExerciseModel) {
        guard let model = exerciseModelArray.last else {
            self.exerciseModelArray.append(exerciseModel)
            return
        }
            
        if !(model.question?.wordID == exerciseModel.question?.wordID && model.type == exerciseModel.type) {
            self.exerciseModelArray.append(exerciseModel)
        }
        
    }
    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    private func addWrongBook(exerciseModel: YXWordExerciseModel) {
        
    }
    
    
    /// 上报关卡
    /// - Parameter test: 参数待定
    /// - Parameter completion: 上报后成功或失败的回调处理
    func reportUnit(test: Any, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        
        completion?(true, nil)
    }
    

    
    //MARK: - private
    private func processExerciseData(result: YXExerciseResultModel?) {
        
        // 处理新学单词
        for wordId in result?.newWords ?? [] {
            
            if let word = self.fetchWord(wordId: wordId) {
                if word.gardeType == 2 {// 小学
                    var exercise = YXWordExerciseModel()
                    exercise.type = .newLearnPrimarySchool
                    exercise.question = word
                    exercise.word = word
                    
                    exerciseModelArray.append(exercise)
                } else if word.gardeType == 3 { // 初中
                    var exercise = YXWordExerciseModel()
                    exercise.type = .newLearnJuniorHighSchool
                    exercise.question = word
                    exercise.word = word
                    
                    exerciseModelArray.append(exercise)
                }
            }
        }
        
        // 处理复习单词
        for review in result?.reviewWords ?? [] {
            
            for step in review.steps ?? [] {
                if review.isNewWord {
                    // 新学单词，需要根据打分来判断，再选择哪个
                    for subStep in step {
                        if subStep.score == self.fetchWordScore(wordId: review.wordId) {
                            var exercise = createExerciseModel(step: subStep)
                            exercise.word = fetchWord(wordId: exercise.question?.wordID ?? 0)
                            exerciseModelArray.append(exercise)
                            break
                        }
                    }
                } else {
                    // 不是新学，只有一个题型
                    if let sp = step.first {
                        var exercise = createExerciseModel(step: sp)
                        exercise.word = fetchWord(wordId: exercise.question?.wordID ?? 0)
                        exerciseModelArray.append(exercise)
                    }
                }
            }
            
        }
        
        
    }
    
    
    private func fetchWord(wordId: Int) -> YXWordModel? {
//        return dao.selectWord(wordId: wordId)
        let json = """
        {
            "word_id" : 1,
            "word" : "good",
            "word_property" : "adj.",
            "word_paraphrase" : "好的;优质的;",
            "word_image" : "http://static.51jiawawa.com/images/goods/20181114165122185.png",
            "symbol_us" : "美/ɡʊd/",
            "symbol_uk" : "英/ɡʊd/",
            "voice_us" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "voice_uk" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "example_en" : "You have such a <font color='#55a7fd'>good</font> chance.",
            "example_cn" : "你有这么一个好的机会。",
            "example_voice": "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "synonym": "great,helpful",
            "antonym": "poor,bad",
            "usage":  ["adj.+n.  early morning 清晨","n.+n.  morning exercise早操"]
        }
        """
        
        
        var word = YXWordModel(JSONString: json)
        word?.wordID = wordId
//        word?.word = (word?.word ?? "") + "\(wordId)"
        return word
        
    }
    

    /// 查询单词练习得分
    /// - Parameter wordId: id
    private func fetchWordScore(wordId: Int) -> Int {
        return 7
    }
    
    
    private func createExerciseModel(step: YXWordStepModel) -> YXWordExerciseModel {
        var exercise = YXWordExerciseModel()
        exercise.type = YXExerciseType(rawValue: step.type) ?? .none
        exercise.question = step.question
        exercise.option = step.option
        exercise.answers = step.answers
        return exercise
    }
    
}




