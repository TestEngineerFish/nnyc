//
//  YXStepConfigDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/21.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStepConfigDao {

    /// 更新学习步骤配置表
    /// - Parameters:
    ///   - stepConfigModel: 学习步骤配置对象
    ///   - block: 完成回调
    func updateTable(_ stepConfigModel: YXStepConfigModel, finished block: ((Bool)->Void)?)

    /// 查询单词记录
    /// - Parameters:
    ///   - step: 学习步骤
    ///   - wordId: 查询单词的ID
    func selecte(step: Int, wordId: Int) -> YXStepModel?

}
