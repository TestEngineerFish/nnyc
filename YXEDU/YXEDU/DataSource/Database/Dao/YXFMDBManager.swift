//
//  YXFMDBManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import FMDB

typealias finishBlock = (Any?,Bool) -> Void

class YXFMDBManager: YYDatabase {
    @objc static let share = YXFMDBManager()


    /// 插入书籍信息
    ///
    /// - Parameters:
    ///   - bookMaterials: 书籍信息列表
    ///   - block: 数据库操作完成后的回调
    @objc func insertBookMaterial(_ bookMaterials: [YXBookMaterialModel], completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.insertBookMaterial.rawValue
        self.normalRunner.inExclusiveTransaction { (db, rollback) in
            for bookMaterial in bookMaterials {
                let parameters: [Any] = [bookMaterial.bookId!, bookMaterial.bookName!, bookMaterial.resPath!, bookMaterial.isFinished!, bookMaterial.materialSize!]
                do {
                    try db.executeUpdate(sql, values: parameters)
                } catch {
                    block(bookMaterial, false)
                    rollback.pointee = true
                    return
                }
            }
            block(nil, true)
        }
    }


    /// 获取书籍信息
    ///
    /// - Parameters:
    ///   - bookIds: 书籍ID
    ///   - block: 数据库操作完成后的回调
    @objc func queryBookMaterial(bookIds: [String], completeBlock block: finishBlock) {
        let parameters = bookIds.joined(separator: ",")
        let sql = String(format: YYSQLManager.NormalSQL.queryBookMaterial.rawValue, parameters)
        self.normalRunner.inDatabase { (db) in
            var words =  [Any]()
            do {
                let result = try db.executeQuery(sql, values: nil)
                while result.next() {
                    guard let word = result.resultDictionary else { continue }
                    words.append(word)
                }
                block(words, !words.isEmpty)
            } catch {
                block(words, false)
            }
        }
    }


    /// 获取所有书籍
    ///
    /// - Parameter block: 数据库操作完成后的回调
    @objc func queryMaterialOfAllBooks(completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.queryMaterialOfAllBooks.rawValue
        self.normalRunner.inDatabase { (db) in
            var words =  [Any]()
            do {
                let result = try db.executeQuery(sql, values: nil)
                while result.next() {
                    guard let word = result.resultDictionary else { continue }
                    words.append(word)
                }
                block(words, !words.isEmpty)
            } catch {
                block(words, false)
            }
        }
    }


    /// 删除书籍
    ///
    /// - Parameters:
    ///   - bookIds: 书籍ID
    ///   - block: 数据库操作完成后的回调
    @objc func deleteBookMaterials(bookIds: [String], completeBlock block: finishBlock) {
        let parameters = bookIds.joined(separator: ",")
        let sql = String(format: YYSQLManager.NormalSQL.deleteBookMaterials.rawValue, parameters)
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: nil)
                block(nil, true)
            } catch {
                block(nil, false)
            }
        }
    }


    /// 删除所有书籍
    ///
    /// - Parameter block: 数据库操作完成后的回调
    @objc func deleteAllBookMaterials(completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.deleteAllBookMaterials.rawValue
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: nil)
                block(nil, true)
            } catch {
                block(nil, false)
            }
        }
    }


    /// 插入单词
    ///
    /// - Parameters:
    ///   - wordsDetail: 单词信息列表
    ///   - block: 数据库操作完成后的回调
    @objc func insertWordsDetail(wordsDetail: [[String:Any]], completeBlock block:(finishBlock)) {
        let sql = YYSQLManager.NormalSQL.insertWordsDetail.rawValue
        self.normalRunner.inExclusiveTransaction { (db, rollback) in
            for wordInfo in wordsDetail {
                let wordId      = wordInfo["wordid"] ?? ""
                let meanings    = wordInfo["meanings"] ?? ""
                let word_root   = wordInfo["word_root"] ?? ""
                let word        = wordInfo["word"] ?? ""
                let usvoice     = wordInfo["usvoice"] ?? ""
                let usphone     = wordInfo["usphone"] ?? ""
                let usage       = wordInfo["usage"] ?? ""
                let ukvoice     = wordInfo["ukvoice"] ?? ""
                let ukphone     = wordInfo["ukphone"] ?? ""
                let synonym     = wordInfo["synonym"] ?? ""
                let speech      = wordInfo["speech"] ?? ""
                let property    = wordInfo["property"] ?? ""
                let paraphrase  = wordInfo["paraphrase"] ?? ""
                let morph       = wordInfo["morph"] ?? ""
                let image       = wordInfo["image"] ?? ""
                let eng         = wordInfo["eng"] ?? ""
                let confusion   = wordInfo["confusion"] ?? ""
                let chs         = wordInfo["chs"] ?? ""
                let antonym     = wordInfo["antonym"] ?? ""
                let bookId      = wordInfo["bookId"] ?? ""
                let toolkitDict = wordInfo["toolkit"] as Any

                let toolkit: String = {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: toolkitDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                        return String(data: jsonData, encoding: .utf8) ?? ""
                    } catch {
                        return ""
                    }
                }()
                let parameters: [Any] = [wordId, meanings,word_root, word, usvoice, usphone, usage, ukvoice,
                                         ukphone, synonym, speech, property, paraphrase, morph, image, eng, confusion, chs,bookId,toolkit,antonym]
                do {
                    try db.executeUpdate(sql, values: parameters)
                } catch {
                    block(wordInfo, false)
                    rollback.pointee = true
                    return
                }
            }
            block(nil, true)
        }
    }


    /// 根据ID,获取单词列表
    ///
    /// - Parameters:
    ///   - wordIds: 单词ID列表
    ///   - block: 数据库操作完成后的回调
    @objc func queryWordsDetail(wordIds: [String], completeBlock block: finishBlock) {
        let parameters = wordIds.joined(separator: ",")
        let sql = String(format: YYSQLManager.NormalSQL.queryWordsDetail.rawValue, parameters)
        self.normalRunner.inDatabase { (db) in
            var words = [Any]()
            do {
                let result = try db.executeQuery(sql, values: nil)
                while result.next() {
                    guard let word = result.resultDictionary else {
                        continue
                    }
                    words.append(word)
                }
                block(words, !words.isEmpty)
            } catch {
                block(words, false)
            }
        }
    }


    /// 模糊匹配word或者paraphrase,获取单词列表
    ///
    /// - Parameters:
    ///   - fuzzyQueryPrefix: 模糊匹配对象
    ///   - block: 数据库操作完成后的回调
    @objc func queryWords(fuzzyQueryPrefix: String, completeBlock block: finishBlock) {
        let sql = String(format: YYSQLManager.NormalSQL.fuzzyQueryWords.rawValue, fuzzyQueryPrefix, fuzzyQueryPrefix)
        self.normalRunner.inDatabase { (db) in
            var words = [Any]()
            do {
                let result = try db.executeQuery(sql, values: nil)
                while result.next() {
                    guard let word = result.resultDictionary else {
                        continue
                    }
                    words.append(word)
                }
                block(words, !words.isEmpty)
            } catch {
                block(words, false)
            }
        }
    }


    /// 插入素材
    ///
    /// - Parameters:
    ///   - model: 素材对象
    ///   - block: 数据库操作完成后的回调
    @objc func insertMaterial(model: YXMaterialModel, completeBlock block: finishBlock) {
        let parameters: [Any] = [model.path    ?? "",
                                 model.resname ?? "",
                                 model.size    ?? "",
                                 model.resid   ?? "",
                                 model.date    ?? ""]
        let sql = YYSQLManager.NormalSQL.insertMaterial.rawValue
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: parameters)
                block(model, true)
            } catch {
                block(model, false)
            }
        }
    }


    /// 覆盖学习记录
    ///
    /// - Parameters:
    ///   - model: 学习记录
    ///   - block: 数据库操作完成后的回调
    @objc func replaceStudyRecord(model: YXStudyRecordModel, completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.replaceStudyRecord.rawValue
        let parameters: [String] = [model.recordid ?? "",
                                    model.bookid ?? "",
                                    model.unitid ?? "",
                                    model.questionidx ?? "",
                                    model.questionid ?? "",
                                    model.learn_status ?? "",
                                    model.uuid ?? "",
                                    model.log ?? ""]
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: parameters)
                block(model, true)
            } catch {
                block(model, false)
            }
        }
    }


    /// 获取所有学习记录
    ///
    /// - Parameter block: 数据库操作完成后的回调
    @objc func queryAllStudyRecord(completeBlock block: @escaping finishBlock) {
        let sql = YYSQLManager.NormalSQL.queryStudyRecord.rawValue
        self.normalRunner.inDatabase { (db) in
            var accountArray = [YXStudyRecordModel]()
            do {
                let result = try db.executeQuery(sql, values: nil)
                while result.next() {
                    let recordId    = result.string(forColumn: "recordid") ?? ""
                    let bookId      = result.string(forColumn: "bookid") ?? ""
                    let unitId      = result.string(forColumn: "unitid") ?? ""
                    let questionIdx = result.string(forColumn: "questionidx") ?? ""
                    let questionId  = result.string(forColumn: "questionid") ?? ""
                    let learnStatus = result.string(forColumn: "learn_status") ?? ""
                    let uuid        = result.string(forColumn: "uuid") ?? ""
                    let log         = result.string(forColumn: "log") ?? ""
                    let dict: [String:String] = ["recordid"     : recordId,
                                                 "bookid"       : bookId,
                                                 "unitid"       : unitId,
                                                 "questionidx"  : questionIdx,
                                                 "questionid"   : questionId,
                                                 "learn_status" : learnStatus,
                                                 "uuid"         : uuid,
                                                 "log"          : log]
                    guard let model = YXStudyRecordModel.yrModel(withJSON: dict) as? YXStudyRecordModel else {
                        continue
                    }
                    accountArray.append(model)
                }
                DispatchQueue.main.async {
                    if accountArray.isEmpty {
                         block(accountArray, true)
                    } else {
                         block(nil, false)
                    }
                }
            } catch {
                block(nil, false)
            }
        }
    }


    /// 根据ID,获取学习记录
    ///
    /// - Parameters:
    ///   - recordId: 记录ID
    ///   - block: 数据库操作完成后的回调
    @objc func queryStudyRecord(by recordId: String, completeBlock block: @escaping finishBlock) {
        let sql = YYSQLManager.NormalSQL.queryStudyRecordById.rawValue
        self.normalRunner.inDatabase { (db) in
            var accountArray = [YXStudyRecordModel]()
            do {
                let result = try db.executeQuery(sql, values: [recordId])
                while result.next() {
                    let recordId    = result.string(forColumn: "recordid") ?? ""
                    let bookId      = result.string(forColumn: "bookid") ?? ""
                    let unitId      = result.string(forColumn: "unitid") ?? ""
                    let questionIdx = result.string(forColumn: "questionidx") ?? ""
                    let questionId  = result.string(forColumn: "questionid") ?? ""
                    let learnStatus = result.string(forColumn: "learn_status") ?? ""
                    let uuid        = result.string(forColumn: "uuid") ?? ""
                    let log         = result.string(forColumn: "log") ?? ""
                    let dict: [String:String] = ["recordid"     : recordId,
                                                 "bookid"       : bookId,
                                                 "unitid"       : unitId,
                                                 "questionidx"  : questionIdx,
                                                 "questionid"   : questionId,
                                                 "learn_status" : learnStatus,
                                                 "uuid"         : uuid,
                                                 "log"          : log]
                    guard let model = YXStudyRecordModel.yrModel(withJSON: dict) as? YXStudyRecordModel else {
                        continue
                    }
                    accountArray.append(model)
                }
                DispatchQueue.main.async {
                    block(accountArray, true)
                }
            } catch {
                block(nil, false)
            }
        }
    }


    /// 根据记录ID,删除学习记录
    ///
    /// - Parameters:
    ///   - model: 学习记录对象
    ///   - block: 数据库操作完成后的回调
    @objc func deleteStudyRecord(model: YXStudyRecordModel, completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.deleteStudyRecord.rawValue
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: nil)
                block(model, true)
            } catch {
                block(model, false)
            }
        }
    }


    /// 删除所有学习记录
    ///
    /// - Parameter block: 数据库操作完成后的回调
    @objc func deleteAllStudyRecord(completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.deleteAllStudyRecord.rawValue
        self.normalRunner.inDatabase { (db) in
            do {
                try db.executeUpdate(sql, values: nil)
                block(nil, true)
            } catch {
                block(nil, false)
            }
        }
    }


    /// 批量删除学习记录
    ///
    /// - Parameters:
    ///   - recordArray: 需要删除的学习记录对象列表
    ///   - block: 数据库操作完成后的回调
    @objc func deleteBatchStudyRecord(recordArray: [YXStudyRecordModel], completeBlock block: finishBlock) {
        let sql = YYSQLManager.NormalSQL.deleteStudyRecord.rawValue
        self.normalRunner.inExclusiveTransaction { (db, rollback) in
            if db.open() {
                db.beginExclusiveTransaction()
                do {
                    for model in recordArray {
                        try db.executeUpdate(sql, values: [model.recordid ?? ""])
                    }
                    db.commit()
                    block(nil, true)
                } catch {
                    rollback.pointee = true
                    db.rollback()
                    block(nil, false)
                }
            }
        }
    }


}
