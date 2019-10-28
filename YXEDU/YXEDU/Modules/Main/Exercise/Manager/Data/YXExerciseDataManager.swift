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
        exerciseModelArray = [YXWordExerciseModel(.lookWordChooseImage),
        YXWordExerciseModel(.lookExampleChooseImage)]
        
        completion?(true, nil)
    }
    
    
    /// 获取一个练习对象
    func fetchOneExerciseModels() -> YXWordExerciseModel? {
        return exerciseModelArray.first
    }
    
    
    /// 错题数据处理，重做
    /// - Parameter wrongExercise: 练习Model
    func addWrongExercise(wrongExercise: YXWordExerciseModel) {
        self.exerciseModelArray.append(wrongExercise)
        
        self.addWrongBook(wrongExercise: wrongExercise)
    }
    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    func addWrongBook(wrongExercise: YXWordExerciseModel) {
        
    }
    
    
    /// 上报关卡
    /// - Parameter test: 参数待定
    /// - Parameter completion: 上报后成功或失败的回调处理
    func reportUnit(test: Any, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        
        completion?(true, nil)
    }
    

}