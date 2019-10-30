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
    
    /// 工厂方法，构建练习视图
    /// - Parameter exerciseModel: 单词数据模型
    static func buildView(exerciseModel: YXWordExerciseModel) -> YXBaseExerciseView {
            
            switch exerciseModel.type {
            //MARK: choose
            case .lookWordChooseImage:
                return YXLookWordChooseImageExerciseView(exerciseModel: exerciseModel)
            case .lookExampleChooseImage:
                return YXLookExampleChooseImageExerciseView(exerciseModel: exerciseModel)
            case .lookWordChooseChinese:
                return YXLookWordChooseChineseExerciseView(exerciseModel: exerciseModel)
            case .lookExampleChooseChinese:
                return YXLookExampleChooseChineseExerciseView(exerciseModel: exerciseModel)
            case .lookChineseChooseWord:
                return YXLookChineseChooseWordExerciseView(exerciseModel: exerciseModel)
            case .lookImageChooseWord:
                return YXLookImageChooseWordExerciseView(exerciseModel: exerciseModel)
                
                
            //MARK: validation
            case .validationWordAndChinese:
                return YXValidationWordAndChineseExerciseView(exerciseModel: exerciseModel)
            case .validationImageAndWord:
                return YXValidationImageAndWordExerciseView(exerciseModel: exerciseModel)
                
                
            //MARK: listen
            case .listenChooseWord:
                return YXListenChooseWordExerciseView(exerciseModel: exerciseModel)
            case .listenChooseChinese:
                return YXListenChooseChineseExerciseView(exerciseModel: exerciseModel)
            case .listenChooseImage:
                return YXListenChooseImageExerciseView(exerciseModel: exerciseModel)
                
                
            //MARK: connect
            case .connectionWordAndChinese:
                return YXConnectionWordAndChineseExerciseView(exerciseModel: exerciseModel)
            case .connectionWordAndImage:
                return YXConnectionWordAndImageExerciseView(exerciseModel: exerciseModel)
                
                
            //MARK: fill
            case .fillWordAccordingToChinese:
                return YXFillWordAccordingToChineseExerciseView(exerciseModel: exerciseModel)
            case .fillWordAccordingToListen:
                return YXFillWordAccordingToListenExerciseView(exerciseModel: exerciseModel)
            case .fillWordAccordingToImage:
                return YXFillWordAccordingToImageExerciseView(exerciseModel: exerciseModel)
            case .fillWordAccordingToChinese_Connection:
                return YXFillWordAccordingToChinese_ConnectionExerciseView(exerciseModel: exerciseModel)
            case .fillWordGroup:
                return YXFillWordGroupExerciseView(exerciseModel: exerciseModel)
                
            default:
                return YXLookWordChooseImageExerciseView(exerciseModel: exerciseModel)
            }
        }
    
}
