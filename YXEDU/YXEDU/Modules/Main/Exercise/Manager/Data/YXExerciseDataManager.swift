//
//  YXExerciseDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习的数据管理器
class YXExerciseDataManager: NSObject {
    
    var exerciseModelArray: [YXWordExerciseModel] = []
    
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchTodayExerciseModels(completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        // --- 测试数据 ----
        let model = YXWordExerciseModel(.fillWordAccordingToChinese_Connection)
        let strArray = ["e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x", "e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x", "e", "sam", "u", "pdsss", "wddesa", "sam", "m", "x"]
        model.wordArray = strArray
        let charModelArray: [YXCharacterModel] = {
            var array = [YXCharacterModel]()
            var index = 0
            for str in model.word {
                let model = YXCharacterModel(str.description, isBlank: index != 0)
                array.append(model)
                index += 1
            }
            return array
        }()
        model.charModelArray = charModelArray
        // ---- ^^^^^ ----
        exerciseModelArray = [
            model,
            YXWordExerciseModel(.listenChooseWord),
            YXWordExerciseModel(.listenChooseChinese),
            YXWordExerciseModel(.listenChooseImage),
            YXWordExerciseModel(.validationWordAndChinese),
            YXWordExerciseModel(.validationImageAndWord),
            YXWordExerciseModel(.lookImageChooseWord),
            YXWordExerciseModel(.lookChineseChooseWord),
            YXWordExerciseModel(.lookWordChooseChinese),
            YXWordExerciseModel(.lookExampleChooseImage),
            YXWordExerciseModel(.lookWordChooseImage),            
            YXWordExerciseModel(.fillWordAccordingToChinese),
            YXWordExerciseModel(.lookWordChooseImage),
            YXWordExerciseModel(.fillWordAccordingToChinese_Connection),
            YXWordExerciseModel(.lookExampleChooseImage)
        ]
        completion?(true, nil)
    }
    
    
    
    /// 加载本地未学完的关卡数据
    func fetchUnCompletionExerciseModels() {
        exerciseModelArray = [
            YXWordExerciseModel(.fillWordAccordingToChinese_Connection),
            YXWordExerciseModel(.fillWordAccordingToChinese),
            
            YXWordExerciseModel(.lookWordChooseImage),
            YXWordExerciseModel(.lookExampleChooseImage)
        ]
    }
    
    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModels() -> YXWordExerciseModel? {
        return exerciseModelArray.first
    }
    
    
    /// 完成一个练习后，答题后删除练习题
    /// - Parameter exerciseModel:
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        self.exerciseModelArray.removeFirst()
        
        if !right {
            self.addWrongExercise(exerciseModel: exerciseModel)
            self.addWrongBook(exerciseModel: exerciseModel)
        }
    }
    
    /// 错题数据处理，重做
    /// - Parameter wrongExercise: 练习Model
    private func addWrongExercise(exerciseModel: YXWordExerciseModel) {
        self.exerciseModelArray.append(exerciseModel)
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
    
    
    
    
}
