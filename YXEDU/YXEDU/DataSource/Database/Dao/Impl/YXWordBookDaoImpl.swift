//
//  YXWordDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper
import FMDB

class YXWordBookDaoImpl: YYDatabase, YXWordBookDao {

    @discardableResult
    func insertBook(book: YXWordBookModel, async: Bool = false) -> Bool {
        let sql = YYSQLManager.WordBookSQL.insertBook.rawValue
        let params: [Any?] = [book.bookId,
                             book.bookName,
                             book.bookWordSourcePath,
                             book.bookHash,
                             book.gradeId,
                             book.gradeType]
        if async {
            self.wordRunnerQueue.inDatabase { (db) in
                db.executeUpdate(sql, withArgumentsIn: params)
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        }
    }
    
    func selectBook(bookId: Int) -> YXWordBookModel? {
        let sql = YYSQLManager.WordBookSQL.selectBook.rawValue
        let params: [Any] = [bookId]
        
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else { return nil }
        
        var book: YXWordBookModel?
        if result.next() {
            book = YXWordBookModel()
            book!.bookId = Int(result.int(forColumn: "bookId"))
            book!.bookName = result.string(forColumn: "bookName")
            book!.bookWordSourcePath = result.string(forColumn: "bookSource")
            book!.bookHash = result.string(forColumn: "bookHash")
            book!.gradeId = Int(result.int(forColumn: "gradeId"))
            book!.gradeType = Int(result.int(forColumn: "gradeType"))
        }
        
        result.close()
        return book
    }

    @discardableResult
    func deleteBook(bookId: Int, async: Bool = false) -> Bool {
        let sql = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let params: [Any] = [bookId]
        if async {
            self.wordRunnerQueue.inDatabase { (db) in
                db.executeUpdate(sql, withArgumentsIn: params)
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        }
    }

    @discardableResult
    func insertWord(word: YXWordModel, async: Bool = false) -> Bool {
        let sql = YYSQLManager.WordBookSQL.insertWord.rawValue
        let partOfSpeechAndMeaningsDataString: String! = word.partOfSpeechAndMeanings?.toJSONString() ?? "[]"
        let deformationsDataString: String! = word.deformations?.toJSONString() ?? "[]"
        let examplessDataString: String! = word.examples?.toJSONString() ?? "[]"
        let fixedMatchsDataString: String! = word.fixedMatchs?.toJSONString() ?? "[]"
        let commonPhrasesDataString: String! = word.commonPhrases?.toJSONString() ?? "[]"
        let wordAnalysisDataString: String! = word.wordAnalysis?.toJSONString() ?? "[]"
        let detailedSyntaxsDataString: String! = word.detailedSyntaxs?.toJSONString() ?? "[]"
        let synonymsData: Data! = try? JSONSerialization.data(withJSONObject: word.synonyms ?? [])
        let antonymsData: Data! = try? JSONSerialization.data(withJSONObject: word.antonyms ?? [])

        let params: [Any?] = [word.wordId,
                              word.word,
                              partOfSpeechAndMeaningsDataString,
                              word.imageUrl,
                              word.englishPhoneticSymbol,
                              word.americanPhoneticSymbol,
                              word.englishPronunciation,
                              word.americanPronunciation,
                              deformationsDataString,
                              examplessDataString,
                              fixedMatchsDataString,
                              commonPhrasesDataString,
                              wordAnalysisDataString,
                              detailedSyntaxsDataString,
                              String(data: synonymsData!, encoding: .utf8),
                              String(data: antonymsData!, encoding: .utf8),
                              word.gradeId,
                              word.gardeType,
                              word.bookId,
                              word.unitId ,
                              word.unitName,
                              word.isExtensionUnit]
        if async {
            self.wordRunnerQueue.inDatabase { (db) in
                db.executeUpdate(sql, withArgumentsIn: params)
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        }

    }
    
    func selectWordByUnitId(unitId: Int) -> [YXWordModel] {
        let sql = YYSQLManager.WordBookSQL.selectWordByUnitId.rawValue
        let params: [Any] = [unitId]
        var wordModelArray = [YXWordModel]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return wordModelArray
        }

        while result.next() {
            let word = createWordModel(result: result)
            wordModelArray.append(word)
        }
        
        result.close()
        return wordModelArray
    }

    func selectWordByBookId(_ bookId: Int) -> [YXWordModel] {
        let sql = YYSQLManager.WordBookSQL.selectWordByBookId.rawValue
        let params: [Any] = [bookId]
        var wordModelArray = [YXWordModel]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return wordModelArray
        }

        while result.next() {
            let word = createWordModel(result: result)
            wordModelArray.append(word)
        }

        result.close()
        return wordModelArray
    }

    @discardableResult
    func deleteWord(bookId: Int, async: Bool = false) -> Bool {
        let sql = YYSQLManager.WordBookSQL.deleteWord.rawValue
        let params: [Any] = [bookId]
        if async {
            self.wordRunnerQueue.inDatabase { (db) in
                db.executeUpdate(sql, withArgumentsIn: params)
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        }
    }
    
    func selectWord(wordId: Int) -> YXWordModel? {
//        print("--------------  bookId", bookId, "------------- wordId", wordId )
        
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [wordId]) else {
//            DDLogError("selectRecordByImageID failed")
            return nil
        }
        
        if result.next() {
            return createWordModel(result: result)
        }
        result.close()
        return nil
    }
    
    func selectWord(bookId: Int, wordId: Int) -> YXWordModel? {
        print("--------------  bookId", bookId, "------------- wordId", wordId )
        
        let sql = YYSQLManager.WordBookSQL.selectWordByBookIdAndWordId.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [bookId, wordId]) else {
//            DDLogError("selectRecordByImageID failed")
            return nil
        }
        
        if result.next() {
            return createWordModel(result: result)
        }
        result.close()
        return nil
    }
    
    
    private func createWordModel(result: FMResultSet) -> YXWordModel {
        var word = YXWordModel()
        
        let partOfSpeechAndMeaningsDataString: String! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]")
        let deformationsDataString: String! = (result.string(forColumn: "deformations") ?? "[]")
        let examplessDatStringa: String! = (result.string(forColumn: "examples") ?? "[]")
        let fixedMatchsDataString: String! = (result.string(forColumn: "fixedMatchs") ?? "[]")
        let commonPhrasesDataString: String! = (result.string(forColumn: "commonPhrases") ?? "[]")
        let wordAnalysisDataString: String! = (result.string(forColumn: "wordAnalysis") ?? "[]")
        let detailedSyntaxsDataString: String! = (result.string(forColumn: "detailedSyntaxs") ?? "[]")
        let synonymsData: Data! = (result.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
        let antonymsData: Data! = (result.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!
        
        word.wordId = Int(result.int(forColumn: "wordId"))
        word.word = result.string(forColumn: "word")
//        word.word = "from.&*@#-$to ..."
        word.partOfSpeechAndMeanings = [YXWordPartOfSpeechAndMeaningModel](JSONString: partOfSpeechAndMeaningsDataString)
        word.imageUrl = result.string(forColumn: "imageUrl")
        word.americanPhoneticSymbol = result.string(forColumn: "americanPhoneticSymbol")
        word.englishPhoneticSymbol = result.string(forColumn: "englishPhoneticSymbol")
        word.americanPronunciation = result.string(forColumn: "americanPronunciation")
        word.englishPronunciation = result.string(forColumn: "englishPronunciation")
        word.deformations = [YXWordDeformationModel](JSONString: deformationsDataString)
        word.examples = [YXWordExampleModel](JSONString: examplessDatStringa)
        word.fixedMatchs = [YXWordFixedMatchModel](JSONString: fixedMatchsDataString)
        word.commonPhrases = [YXWordCommonPhrasesModel](JSONString: commonPhrasesDataString)
        word.wordAnalysis = [YXWordAnalysisModel](JSONString: wordAnalysisDataString)
        word.detailedSyntaxs = [YXWordDetailedSyntaxModel](JSONString: detailedSyntaxsDataString)
        word.synonyms = try? (JSONSerialization.jsonObject(with: synonymsData, options: .mutableContainers) as! [String])
        word.antonyms = try? (JSONSerialization.jsonObject(with: antonymsData, options: .mutableContainers) as! [String])
        word.gradeId = Int(result.int(forColumn: "gradeId"))
        word.gardeType = Int(result.int(forColumn: "gardeType"))
        word.bookId = Int(result.int(forColumn: "bookId"))
        word.unitId = Int(result.int(forColumn: "unitId"))
        word.unitName = result.string(forColumn: "unitName")
        word.isExtensionUnit = result.bool(forColumn: "isExtensionUnit")
        
        return word
    }
}
