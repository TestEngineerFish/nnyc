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
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params as [Any])
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

            result?.close()

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
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
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

            wordModelArray.append(word)
        }

        result.close()
        return wordModelArray
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
        result.close()
        return nil
    }
}
