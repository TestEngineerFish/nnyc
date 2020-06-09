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
import Bugly

class YXWordBookDaoImpl: YYDatabase, YXWordBookDao {

    /// 更新词书中所有单词
    /// - Parameter bookModel: 词书对象
    func updateWords(bookModel: YXWordBookModel) {
        guard let bookId = bookModel.bookId, let unitsList = bookModel.units, let newHash = bookModel.bookHash else {
            YXWordBookResourceManager.shared.downloadError(with: bookModel.bookId, newHash: bookModel.bookHash, error: "数据解析失败")
            return
        }
        let errorMsg = "当前正在学习中，回滚DB操作，不再写入数据"
        let deleteWordsSQL = YYSQLManager.WordBookSQL.deleteWord.rawValue
        let insertWordSQL  = YYSQLManager.WordBookSQL.insertWord.rawValue
        let deleteBookSQL  = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let insertBookSQL  = YYSQLManager.WordBookSQL.insertBook.rawValue
        let deleteWordsParams: [Any] = [bookId]
        let deleteBookParams: [Any]  = [bookId]
        let insertBookParams: [Any]  = [bookId,
                                   bookModel.bookName ?? "",
                                   bookModel.bookWordSourcePath ?? "",
                                   newHash,
                                   bookModel.gradeId ?? 0,
                                   bookModel.gradeType ?? 0]
        self.wordRunnerQueue.inImmediateTransaction { (db, rollback) in
            // 遍历添加单词
            var lastUnit = false
            if YXWordBookResourceManager.stop {
                YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: errorMsg)
                db.rollback()
                return
            }
            // 删除词书下所有单词
            let deleteWordsSuccess = db.executeUpdate(deleteWordsSQL, withArgumentsIn: deleteWordsParams)
            let msg = String(format: "删除:%@，id:%d下所有单词", bookModel.bookName ?? "", bookId)
            if deleteWordsSuccess {
//                Bugly.reportError(NSError(domain: msg + "成功", code: 0, userInfo: nil))
                YXLog(msg + "成功")
            } else {
                Bugly.reportError(NSError(domain: msg + "失败", code: 0, userInfo: nil))
                YXLog(msg + "失败")
            }
            for (unitIndex, unitModel) in unitsList.enumerated() {
                guard let wordsList = unitModel.words else {
                    continue
                }
                if YXWordBookResourceManager.stop {
                    YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: errorMsg)
                    db.rollback()
                    return
                }
                if unitIndex == unitsList.count - 1 {
                    lastUnit = true
                }
                for (index, var wordModel) in wordsList.enumerated() {
                    if YXWordBookResourceManager.stop {
                        YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: errorMsg)
                        db.rollback()
                        return
                    }
                    wordModel.gradeId         = bookModel.gradeId
                    wordModel.gardeType       = bookModel.gradeType ?? 1
                    wordModel.bookId          = bookModel.bookId
                    wordModel.unitId          = unitModel.unitId
                    wordModel.unitName        = unitModel.unitName
                    wordModel.isExtensionUnit = unitModel.isExtensionUnit
                    // 插入单词
                    let insertWordParams  = self.getWordSQLParams(word: wordModel)
                    let insertWrodSuccess = db.executeUpdate(insertWordSQL, withArgumentsIn: insertWordParams)
                    if !insertWrodSuccess {
                        let msg = String(format: "插入单词:%@， id:%d失败", wordModel.word ?? "", wordModel.wordId ?? 0)
                        Bugly.reportError(NSError(domain: msg, code: 0, userInfo: nil))
                        YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: msg)
                        db.rollback()
                        return
                    }
                    if index == wordsList.count - 1 && lastUnit {
                        YXLog(String(format: "保存:%@，id:%d下所有单词成功", bookModel.bookName ?? "", bookId))
                        // 删除旧词书
                        let deleteBookSuccess = db.executeUpdate(deleteBookSQL, withArgumentsIn: deleteBookParams)
                        var msg = String(format: "删除词书:%@，id:%d", bookModel.bookName ?? "", bookId)
                        if deleteBookSuccess {
//                            Bugly.reportError(NSError(domain: msg + "成功", code: 0, userInfo: nil))
                            YXLog(msg + "成功")
                        } else {
                            Bugly.reportError(NSError(domain: msg + "失败", code: 0, userInfo: nil))
                            YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: msg + "失败")
                            db.rollback()
                            return
                        }
                        // 添加新词书
                        let insertBookSuccess = db.executeUpdate(insertBookSQL, withArgumentsIn: insertBookParams)
                        msg = String(format: "保存词书:%@，id:%d", bookModel.bookName ?? "", bookId)
                        if insertBookSuccess {
//                            Bugly.reportError(NSError(domain: msg + "成功", code: 0, userInfo: nil))
                            YXLog(msg + "成功")
                        } else {
                            Bugly.reportError(NSError(domain: msg + "失败", code: 0, userInfo: nil))
                            YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: msg + "失败")
                            db.rollback()
                            return
                        }
                        if !YXWordBookResourceManager.downloadDataList.isEmpty {
                            YXWordBookResourceManager.downloadDataList.removeFirst()
                        }
                        YXLog("当前剩余下载词书数量：\(YXWordBookResourceManager.downloadDataList.count)/\(YXWordBookResourceManager.totalDownloadCount)")
                        YXWordBookResourceManager.shared.downloadError(with: bookId, newHash: newHash, error: nil)
                    }
                }
            }
        }
    }

    /// 仅测试用，删除所用词书和单词
    func deleteAll() {
        let deleteBooksSQL = YYSQLManager.WordBookSQL.deleteAllBooks.rawValue
        let deleteWordsSQL = YYSQLManager.WordBookSQL.deleteAllWords.rawValue
        self.wordRunnerQueue.inTransaction { (db, rollback) in
            db.executeUpdate(deleteBooksSQL, withArgumentsIn: [])
            db.executeUpdate(deleteWordsSQL, withArgumentsIn: [])
            DispatchQueue.main.async {
                YXUtils.showHUD(kWindow, title: "删除成功")
            }
        }
    }

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
                db.executeUpdate(sql, withArgumentsIn: params as [Any])
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params as [Any])
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
        let params = self.getWordSQLParams(word: word)
        if async {
            self.wordRunnerQueue.inDatabase { (db) in
                db.executeUpdate(sql, withArgumentsIn: params as [Any])
            }
            return true
        } else {
            return self.wordRunner.executeUpdate(sql, withArgumentsIn: params as [Any])
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
    func deleteWords(bookId: Int, async: Bool = false) -> Bool {
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
    
    func selectBookIdList() -> [Int] {
        var bookIdList = [Int]()
        let sql = YYSQLManager.WordBookSQL.selectBookIdList.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return bookIdList
        }
        while result.next() {
            let bookId = Int(result.int(forColumn: "bookId"))
            bookIdList.append(bookId)
        }
        return bookIdList
    }
    
    func selectWord(wordId: Int) -> YXWordModel? {
        
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [wordId]) else {
            return nil
        }
        
        if result.next() {
            return createWordModel(result: result)
        }
        result.close()
        return nil
    }
    
    func selectWord(bookId: Int, wordId: Int) -> YXWordModel? {
//        YXLog("查找--------------  bookId", bookId, "------------- wordId", wordId )
        
        let sql = YYSQLManager.WordBookSQL.selectWordByBookIdAndWordId.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [bookId, wordId]) else {
            return nil
        }
        
        if result.next() {
            return createWordModel(result: result)
        }
        result.close()
        return nil
    }

    // MARK: ==== Tools ====


    /// 获取单词表的所有字段参数
    /// - Parameter word: 单词对象
    /// - Returns: 单词表的所有字段参数
    private func getWordSQLParams(word: YXWordModel) -> [Any] {
        let wordId                            = word.wordId ?? 0
        let wordStr                           = word.word ?? ""
        let imageUrl                          = word.imageUrl ?? ""
        let englishPhoneticSymbol             = word.englishPhoneticSymbol ?? ""
        let americanPhoneticSymbol            = word.americanPhoneticSymbol ?? ""
        let englishPronunciation              = word.englishPronunciation ?? ""
        let americanPronunciation             = word.americanPronunciation ?? ""
        let partOfSpeechAndMeaningsDataString = word.partOfSpeechAndMeanings?.toJSONString() ?? "[]"
        let deformationsDataString: String    = word.deformations?.toJSONString() ?? "[]"
        let examplessDataString: String       = word.examples?.toJSONString() ?? "[]"
        let fixedMatchsDataString: String     = word.fixedMatchs?.toJSONString() ?? "[]"
        let commonPhrasesDataString: String   = word.commonPhrases?.toJSONString() ?? "[]"
        let wordAnalysisDataString: String    = word.wordAnalysis?.toJSONString() ?? "[]"
        let detailedSyntaxsDataString: String = word.detailedSyntaxs?.toJSONString() ?? "[]"
        let synonyms                          = word.synonyms?.toJson() ?? ""
        let antonyms                          = word.antonyms?.toJson() ?? ""
        let gradeId                           = word.gradeId ?? 0
        let gardeType                         = word.gardeType ?? 0
        let bookId                            = word.bookId ?? 0
        let unitId                            = word.unitId ?? 0
        let unitName                          = word.unitName ?? ""
        let isExtensionUnit                   = word.isExtensionUnit

        let params: [Any] = [wordId,
                             wordStr,
                             partOfSpeechAndMeaningsDataString,
                             imageUrl,
                             englishPhoneticSymbol,
                             americanPhoneticSymbol,
                             englishPronunciation,
                             americanPronunciation,
                             deformationsDataString,
                             examplessDataString,
                             fixedMatchsDataString,
                             commonPhrasesDataString,
                             wordAnalysisDataString,
                             detailedSyntaxsDataString,
                             synonyms,
                             antonyms,
                             gradeId,
                             gardeType,
                             bookId,
                             unitId,
                             unitName,
                             isExtensionUnit]
        return params
    }
    
    private func createWordModel(result: FMResultSet) -> YXWordModel {
        var word = YXWordModel()
        
        let partOfSpeechAndMeaningsDataString: String! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]")
        let deformationsDataString: String!    = (result.string(forColumn: "deformations") ?? "[]")
        let examplessDatStringa: String!       = (result.string(forColumn: "examples") ?? "[]")
        let fixedMatchsDataString: String!     = (result.string(forColumn: "fixedMatchs") ?? "[]")
        let commonPhrasesDataString: String!   = (result.string(forColumn: "commonPhrases") ?? "[]")
        let wordAnalysisDataString: String!    = (result.string(forColumn: "wordAnalysis") ?? "[]")
        let detailedSyntaxsDataString: String! = (result.string(forColumn: "detailedSyntaxs") ?? "[]")
        let synonymsData: Data! = (result.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
        let antonymsData: Data! = (result.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!

        word.wordId                  = Int(result.int(forColumn: "wordId"))
        word.word                    = result.string(forColumn: "word")
        word.partOfSpeechAndMeanings = [YXWordPartOfSpeechAndMeaningModel](JSONString: partOfSpeechAndMeaningsDataString)
        word.imageUrl                = result.string(forColumn: "imageUrl")
        word.americanPhoneticSymbol  = result.string(forColumn: "americanPhoneticSymbol")
        word.englishPhoneticSymbol   = result.string(forColumn: "englishPhoneticSymbol")
        word.americanPronunciation   = result.string(forColumn: "americanPronunciation")
        word.englishPronunciation    = result.string(forColumn: "englishPronunciation")
        word.deformations            = [YXWordDeformationModel](JSONString: deformationsDataString)
        word.examples                = [YXWordExampleModel](JSONString: examplessDatStringa)
        word.fixedMatchs             = [YXWordFixedMatchModel](JSONString: fixedMatchsDataString)
        word.commonPhrases           = [YXWordCommonPhrasesModel](JSONString: commonPhrasesDataString)
        word.wordAnalysis            = [YXWordAnalysisModel](JSONString: wordAnalysisDataString)
        word.detailedSyntaxs         = [YXWordDetailedSyntaxModel](JSONString: detailedSyntaxsDataString)
        word.synonyms                = try? (JSONSerialization.jsonObject(with: synonymsData, options: .mutableContainers) as! [String])
        word.antonyms                = try? (JSONSerialization.jsonObject(with: antonymsData, options: .mutableContainers) as! [String])
        word.gradeId                 = Int(result.int(forColumn: "gradeId"))
        word.gardeType               = Int(result.int(forColumn: "gardeType"))
        word.bookId                  = Int(result.int(forColumn: "bookId"))
        word.unitId                  = Int(result.int(forColumn: "unitId"))
        word.unitName                = result.string(forColumn: "unitName")
        word.isExtensionUnit         = result.bool(forColumn: "isExtensionUnit")
        
        return word
    }
}
