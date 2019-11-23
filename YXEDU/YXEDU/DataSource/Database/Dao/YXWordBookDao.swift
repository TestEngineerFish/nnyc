//
//  YXWordDao.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 词书本地数据接口
protocol YXWordBookDao {
    
    /// 添加词书
    /// - Parameter book: 词书对象
    func insertBook(book: YXWordBookModel,  completion: finishBlock?)
    
    /// 删除词书
    /// - Parameter bookId: 词书 id
    func deleteBook(bookId: Int,  completion: finishBlock?)
    
    /// 查询词书
    /// - Parameter bookId: 词书 id
    func selectBook(bookId: Int,  completion: finishBlock)
    
    /// 插入单词
    /// - Parameter word: 单词对象
    func insertWord(word: YXWordModel,  completion: finishBlock?)
    
    /// 删除单词
    /// - Parameter bookId: 词书 id
    func deleteWord(bookId: Int,  completion: finishBlock?)
    
    /// 查询单词
    /// - Parameter wordId: 单词 id
    func selectWord(wordId: Int,  completion: finishBlock)
    
    /// 通过单元 ID 查询单词
    /// - Parameter unitId: 单元 id
    func selectWordByUnitId(unitId: Int) -> [YXWordModel]
    
    
    
    /// 查询单词
    /// - Parameter wordId: 单词 id
    func selectWord(wordId: Int) -> YXWordModel?
}
