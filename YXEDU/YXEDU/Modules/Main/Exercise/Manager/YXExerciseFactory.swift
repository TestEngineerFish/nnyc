//
//  YXExerciseFactory.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXExerciseFactory {
    
    static func buildExerciseView(type: YXExerciseType) -> YXBaseExerciseView {
        
        return YXBaseExerciseView()
    }
    
}
