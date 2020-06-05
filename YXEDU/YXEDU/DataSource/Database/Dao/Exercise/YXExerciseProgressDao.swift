//
//  YXExerciseProgressDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


// TODO: ----------- 进度管理
protocol YXExerciseProgressDao {
    // TODO: ==== 查询 ====
    /// 查询错误次数
    func selectErrorCount(wordId: Int) -> Int
    
    // TODO: ==== 插入 ====
    /// 插入错误次数
    func insertErrorCount(wordId: Int) -> Bool
    
    // TODO: ==== 更新 ====
    /// update错误次数
    func updateErrorCount(wordId: Int) -> Bool
    
    // TODO: ==== 更新 ====
    /// update错误次数
    func deleteErrorCount(wordId: Int) -> Bool
}
