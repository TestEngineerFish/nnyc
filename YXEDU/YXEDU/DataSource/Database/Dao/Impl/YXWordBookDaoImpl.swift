//
//  YXWordDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

class YXWordBookDaoImpl: YYDatabase, YXWordBookDao {

    func insertBook(book: YXWordBookModel, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.insertBook.rawValue
        let params: [Any?] = [book.bookId,
                             book.bookName,
                             book.bookSource,
                             book.bookHash,
                             book.gradeId,
                             book.gradeType]
        
        self.wordRunner.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion(nil, isSuccess)
        }
    }
    
    func selectBook(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunner.inDatabase { (db) in
            let result = db.executeQuery(sql, withArgumentsIn: params)
            completion(result, result != nil)
        }
    }
    
    func deleteBook(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunner.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            guard isSuccess else {
                completion(nil, false)
                return
            }
            
            deleteWord(bookId: bookId) { (result, isSuccess) in
                completion(nil, isSuccess)
            }
        }
    }
    
    func insertWord(word: YXWordModel, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.insertWord.rawValue
        let params: [Any?] = [word.wordId,
                              word.word,
                              word.partOfSpeech,
                              word.meaning,
                              word.imageUrl,
                              word.englishPhoneticSymbol,
                              word.americanPhoneticSymbol,
                              word.englishPronunciation,
                              word.americanPronunciation,
                              word.englishExample,
                              word.chineseExample,
                              word.examplePronunciation,
                              word.usages,
                              word.synonym,
                              word.antonym,
                              word.testCenter,
                              word.deformation,
                              word.gradeId,
                              word.gardeType,
                              word.bookId,
                              word.unitId ,
                              word.unitName,
                              word.isExtensionUnit]
        
        self.wordRunner.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion(nil, isSuccess)
        }
    }
    
    func selectWord(wordId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        let params: [Any] = [wordId]
        
        self.wordRunner.inDatabase { (db) in
            let result = db.executeQuery(sql, withArgumentsIn: params)
            
//            result?.next()
            
            
            completion(result, result != nil)
        }
    }
    
    func deleteWord(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.deleteWord.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunner.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion(nil, isSuccess)
        }
    }
}
