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
                             book.bookJsonSourcePath,
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
            var book = YXWordBookModel()
            
            book.bookId = Int(result?.int(forColumn: "bookId") ?? 0)
            book.bookName = result?.string(forColumn: "bookName")
            book.bookJsonSourcePath = result?.string(forColumn: "bookSource")
            book.bookHash = result?.string(forColumn: "bookHash")
            book.gradeId = Int(result?.int(forColumn: "gradeId") ?? 0)
            book.gradeType = Int(result?.int(forColumn: "gradeType") ?? 0)

            let isSuccess = result?.next() ?? false
            completion(isSuccess ? book : nil, isSuccess)
        }
    }
    
    func deleteBook(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunner.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion(nil, isSuccess)
        }
    }
    
    func insertWord(word: YXWordModel, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.insertWord.rawValue
        let usagesData: Data! = try? JSONSerialization.data(withJSONObject: word.usages ?? [])
        
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
                              String(data: usagesData!, encoding: .utf8),
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
            let usagesData: Data! = (result?.string(forColumn: "usages") ?? "[]").data(using: .utf8)!

            var word = YXWordModel()
            
            word.wordId = Int(result?.int(forColumn: "wordId") ?? 0)
            word.word = result?.string(forColumn: "word")
            word.partOfSpeech = result?.string(forColumn: "partOfSpeech")
            word.meaning = result?.string(forColumn: "meaning")
            word.imageUrl = result?.string(forColumn: "imageUrl")
            word.americanPhoneticSymbol = result?.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result?.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result?.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result?.string(forColumn: "englishPronunciation")
            word.englishExample = result?.string(forColumn: "englishExample")
            word.chineseExample = result?.string(forColumn: "chineseExample")
            word.examplePronunciation = result?.string(forColumn: "examplePronunciation")
            word.usages = try? (JSONSerialization.jsonObject(with: usagesData, options: .mutableContainers) as! [String])
            word.synonym = result?.string(forColumn: "synonym")
            word.antonym = result?.string(forColumn: "antonym")
            word.testCenter = result?.string(forColumn: "testCenter")
            word.deformation = result?.string(forColumn: "deformation")
            word.gradeId = Int(result?.int(forColumn: "gradeId") ?? 0)
            word.gardeType = Int(result?.int(forColumn: "gardeType") ?? 0)
            word.bookId = Int(result?.int(forColumn: "bookId") ?? 0)
            word.unitId = Int(result?.int(forColumn: "unitId") ?? 0)
            word.unitName = result?.string(forColumn: "unitName")
            word.isExtensionUnit = result?.bool(forColumn: "isExtensionUnit") ?? false
            
            let isSuccess = result?.next() ?? false
            completion(isSuccess ? word : nil, isSuccess)
        }
    }
    
    func selectWordByUnitId(_ unitId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectWordByUnitId.rawValue
        let params: [Any] = [unitId]
        
        self.wordRunner.inDatabase { (db) in
            let result = db.executeQuery(sql, withArgumentsIn: params)
            let usagesData: Data! = (result?.string(forColumn: "usages") ?? "[]").data(using: .utf8)!

            var words: [YXWordModel] = []
            
            while result?.next() ?? false {
                var word = YXWordModel()
                
                word.wordId = Int(result?.int(forColumn: "wordId") ?? 0)
                word.word = result?.string(forColumn: "word")
                word.partOfSpeech = result?.string(forColumn: "partOfSpeech")
                word.meaning = result?.string(forColumn: "meaning")
                word.imageUrl = result?.string(forColumn: "imageUrl")
                word.americanPhoneticSymbol = result?.string(forColumn: "americanPhoneticSymbol")
                word.englishPhoneticSymbol = result?.string(forColumn: "englishPhoneticSymbol")
                word.americanPronunciation = result?.string(forColumn: "americanPronunciation")
                word.englishPronunciation = result?.string(forColumn: "englishPronunciation")
                word.englishExample = result?.string(forColumn: "englishExample")
                word.chineseExample = result?.string(forColumn: "chineseExample")
                word.examplePronunciation = result?.string(forColumn: "examplePronunciation")
                word.usages = try? JSONSerialization.jsonObject(with: usagesData, options: .mutableContainers) as? [String] ?? []
                word.synonym = result?.string(forColumn: "synonym")
                word.antonym = result?.string(forColumn: "antonym")
                word.testCenter = result?.string(forColumn: "testCenter")
                word.deformation = result?.string(forColumn: "deformation")
                word.gradeId = Int(result?.int(forColumn: "gradeId") ?? 0)
                word.gardeType = Int(result?.int(forColumn: "gardeType") ?? 0)
                word.bookId = Int(result?.int(forColumn: "bookId") ?? 0)
                word.unitId = Int(result?.int(forColumn: "unitId") ?? 0)
                word.unitName = result?.string(forColumn: "unitName")
                word.isExtensionUnit = result?.bool(forColumn: "isExtensionUnit") ?? false
                
                words.append(word)
            }
            
            let isSuccess = result?.next() ?? false
            completion(isSuccess ? words : nil, isSuccess)
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
