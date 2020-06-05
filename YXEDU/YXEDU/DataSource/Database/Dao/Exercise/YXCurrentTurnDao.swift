//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXCurrentTurnDao {
    // 更新当前练习的数据
    func updateCurrentExercise(type: YXLearnType,bookId: Int, unitId: Int) -> Bool
    
    
    /// 删除当前练习的数据
    func deleteCurrentExercise() -> Bool
}
