//
//  YXExerciseFactory.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习子界面工厂
struct YXExerciseViewFactory {
    
    static func buildView(exerciseModel: YXWordExerciseModel) -> YXExerciseView {
        
        return YXExerciseView()
        
        
//        switch exerciseModel.type {
//        case .lookWordChooseImage:
//            return YXLookWordChooseImageExerciseView(exerciseModel: exerciseModel)
//
//
////            case .lookWordChooseChinese:
//        default:
//            return YXLookWordChooseImageExerciseView(exerciseModel: exerciseModel)
//        }
    }
    
    
    
    
    
    
    
    
}
