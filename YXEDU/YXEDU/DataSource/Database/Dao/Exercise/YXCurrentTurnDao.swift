//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXCurrentTurnDao {
    
    func insertCurrentTurn() -> Bool
    
    
    func queryExercise() -> YXExerciseModel?
    
    
    func updateExerciseFinishStatus() -> Bool
    
    
    /// 删除当前练习的数据
    func deleteCurrentTurn() -> Bool
}
