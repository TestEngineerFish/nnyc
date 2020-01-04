//
//  YXSearchHistoryDao.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

/// 搜索本地数据接口
protocol YXSearchHistoryDao {
    /// 插入单词
    /// - Parameter word: 单词对象
    func insertWord(word: YXSearchWordModel) -> Bool
    
    /// 查询单词
    /// - Parameter wordId: 单词 id
    func selectWord() -> [YXSearchWordModel]
    
    /// 删除所有的历史单词
    func deleteAllWord() -> Bool
}
