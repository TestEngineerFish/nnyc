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
//    func insertBook(book: YXWordBookModel) -> Bool
    func insertBook(book: YXWordBookModel,  completion: finishBlock)
    
    
    /// 删除词书
    /// - Parameter bookId: 词书 id
    func deleteBook(bookId: Int) -> Bool
    
    /// 查询词书hash值，判断版本
    /// - Parameter bookId: 词书 id
    func selectBookHash(bookId: Int) -> String
    
    
    /// 插入单词
    /// - Parameter word: 单词对象
    func insertWord(word: YXWordModel) -> Bool
    
    /// 删除单词
    /// - Parameter bookId: 词书 id
    func deleteWord(bookId: Int) -> Bool
    
    /// 查询单词
    /// - Parameter wordId: 单词 id
    func selectWord(wordId: Int) -> YXWordModel?
}
