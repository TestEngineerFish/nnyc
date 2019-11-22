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

    func insertBook(book: YXWordBookModel, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.insertBook.rawValue
        let params: [Any?] = [book.bookId,
                             book.bookName,
                             book.bookJsonSourcePath,
                             book.bookHash,
                             book.gradeId,
                             book.gradeType]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    func selectBook(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
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
    
    func deleteBook(bookId: Int, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    func insertWord(word: YXWordModel, completion: finishBlock? = nil) {
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
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    func selectWord(wordId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        let params: [Any] = [wordId]
        
        self.wordRunnerQueue.inDatabase { (db) in
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
    
    func selectWordByUnitId(unitId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectWordByUnitId.rawValue
        let params: [Any] = [unitId]
        
        self.wordRunnerQueue.inDatabase { (db) in
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
    
    func deleteWord(bookId: Int, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.deleteWord.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    
    func selectWord(wordId: Int) -> YXWordModel? {
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [wordId]) else {
//            DDLogError("selectRecordByImageID failed")
            return nil
        }
        
        if result.next() {
            var word = YXWordModel()
            
            let usagesData: Data! = (result.string(forColumn: "usages") ?? "[]").data(using: .utf8)!
                        
            word.wordId = Int(result.int(forColumn: "wordId"))
            word.word = result.string(forColumn: "word")
            word.partOfSpeech = result.string(forColumn: "partOfSpeech")
            word.meaning = result.string(forColumn: "meaning")
            word.imageUrl = result.string(forColumn: "imageUrl")
            word.americanPhoneticSymbol = result.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result.string(forColumn: "englishPronunciation")
            word.englishExample = result.string(forColumn: "englishExample")            
            word.chineseExample = result.string(forColumn: "chineseExample")
            word.examplePronunciation = result.string(forColumn: "examplePronunciation")
            word.usages = try? (JSONSerialization.jsonObject(with: usagesData, options: .mutableContainers) as! [String])
            word.synonym = result.string(forColumn: "synonym")
            word.antonym = result.string(forColumn: "antonym")
            word.testCenter = result.string(forColumn: "testCenter")
            word.deformation = result.string(forColumn: "deformation")
            word.gradeId = Int(result.int(forColumn: "gradeId"))
            word.gardeType = Int(result.int(forColumn: "gardeType"))
            word.bookId = Int(result.int(forColumn: "bookId"))
            word.unitId = Int(result.int(forColumn: "unitId"))
            word.unitName = result.string(forColumn: "unitName")
            word.isExtensionUnit = result.bool(forColumn: "isExtensionUnit")
            
            return word
        }
        result.close()
        return nil
        
//        let json = """
//        {
//            "word_id" : 1,
//            "word" : "overnight",
//            "word_property" : "adv",
//            "word_paraphrase" : "在晚上, 在夜里",
//            "word_image" : "http://static.51jiawawa.com/images/goods/20181114165122185.png",
//            "symbol_us" : "美/ɡʊd/",
//            "symbol_uk" : "英/ɡʊd/",
//            "voice_us" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "voice_uk" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "example_en" : "You have such a <font color='#55a7fd'>good</font> chance.",
//            "example_cn" : "你有这么一个好的机会。",
//            "example_voice": "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "synonym": "great,helpful",
//            "antonym": "poor,bad",
//            "usage":  ["adj.+n.  early morning 清晨","n.+n.  morning exercise早操"]
//        }
//        """
//
//
//        var word = YXWordModel(JSONString: json)
//        word?.wordId = wordId
//        word?.gradeId = 1
//        //        word?.word = (word?.word ?? "") + "\(wordId)"
//        return word
    }
}
