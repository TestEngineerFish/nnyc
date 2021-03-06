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

    // TODO: ==== 插入 ====
    /// 添加词书
    /// - Parameter book: 词书对象
    func insertBook(book: YXWordBookModel, async: Bool) -> Bool

    /// 插入单词
    /// - Parameter word: 单词对象
    func insertWord(word: YXWordModel, async: Bool) -> Bool

    // TODO: ==== 删除 ====
    /// 删除词书
    /// - Parameter bookId: 词书 id
    func deleteBook(bookId: Int, async: Bool) -> Bool

    /// 删除单词
    /// - Parameter bookId: 词书 id
    func deleteWords(bookId: Int, async: Bool) -> Bool
    
    // TODO: ==== 查询 ====
    /// 查询词书
    /// - Parameter bookId: 词书 id
    func selectBook(bookId: Int) -> YXWordBookModel?

    /// 通过书 ID 查询单词
    /// - Parameter bookId: 书ID
    func selectWordByBookId(_ bookId: Int) -> [YXWordModel]

    /// 通过单元 ID 查询单词
    /// - Parameter unitId: 单元 id
    func selectWordByUnitId(unitId: Int) -> [YXWordModel]
    
    /// 查询单词
    /// - Parameter wordId: 单词 id
    func selectWord(wordId: Int) -> YXWordModel?
    func selectWord(bookId: Int, wordId: Int) -> YXWordModel?
    
}
