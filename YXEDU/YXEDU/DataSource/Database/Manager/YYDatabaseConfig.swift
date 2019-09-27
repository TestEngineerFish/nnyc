//
//  YYDatabaseConfig.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

//MARK: 建表语句 =========================
struct YYSQLManager {

    // 创建普通数据表
    static let CreateNormalTables: [String] = [CreateNormalTableSQLs.CreateMaterialTable.rawValue,
                                               CreateNormalTableSQLs.CreateStudyRecordTable.rawValue,
                                               CreateNormalTableSQLs.CreateWordsDetailTable.rawValue,
                                               CreateNormalTableSQLs.CreateBookMaterialTable.rawValue]
}

extension YYSQLManager {

    // MARK: Create Table

    enum  CreateNormalTableSQLs: String {
        case CreateMaterialTable =
        """
        CREATE TABLE IF NOT EXISTS MATERIAL_INFO (id INTEGER PRIMARY KEY autoincrement, path TEXT NOT NULL, resname TEXT NOT NULL, size TEXT NOT NULL, resid TEXT NOT NULL, date DATE NOT NULL, UNIQUE(resid))
        """
        case CreateStudyRecordTable =
        """
        CREATE TABLE IF NOT EXISTS STUDYPROGRESS_INFO (id INTEGER PRIMARY KEY autoincrement, bookid TEXT NOT NULL, unitid TEXT NOT NULL, questionidx TEXT NOT NULL, questionid TEXT NOT NULL, uuid TEXT NOT NULL, learn_status TEXT NOT NULL, recordid TEXT NOT NULL, log TEXT NOT NULL, UNIQUE(recordid))
        """
        case CreateWordsDetailTable =
        """
        CREATE TABLE IF NOT EXISTS T_WORDSDETAIL_INFO(
        wordid      TEXT PRIMARY KEY NOT NULL,
        meanings    TEXT ,
        word_root   TEXT ,
        word        TEXT ,
        usvoice     TEXT ,
        usphone     TEXT ,
        usage       TEXT ,
        ukvoice     TEXT ,
        ukphone     TEXT ,
        synonym     TEXT ,
        speech      TEXT ,
        property    TEXT ,
        paraphrase  TEXT ,
        morph       TEXT ,
        image       TEXT ,
        eng         TEXT ,
        confusion   TEXT ,
        chs         TEXT ,
        bookId      TEXT ,
        toolkit     TEXT ,
        antonym     TEXT
        )
        """
        case CreateBookMaterialTable =
        """
        CREATE TABLE IF NOT EXISTS T_BOOKMATERIAL(
        bookId          TEXT PRIMARY KEY NOT NULL,
        bookName        TEXT,
        resPath         TEXT,
        isFinished      TEXT,
        materialSize    TEXT
        )
        """
    }

    // MARK: Update & Select

    enum NormalSQL: String {
        case insertBookMaterial =
        """
            INSERT OR REPLACE INTO T_BOOKMATERIAL
            (bookId, bookName, resPath, isFinished, materialSize)
            VALUES (?, ?, ?, ?, ?)
        """
        case queryBookMaterial =
        """
            SELECT * FROM T_BOOKMATERIAL
            WHERE bookId IN (%@)
        """
        case queryMaterialOfAllBooks =
        """
            SELECT * FROM T_BOOKMATERIAL
        """
        case deleteBookMaterials =
        """
            DELETE FROM T_BOOKMATERIAL
            WHERE bookId IN (%@)
        """
        case deleteAllBookMaterials =
        """
            DELETE FROM T_BOOKMATERIAL
        """
        case insertWordsDetail =
        """
            INSERT OR REPLACE INTO T_WORDSDETAIL_INFO
            (wordid, meanings,word_root, word, usvoice, usphone, usage, ukvoice, ukphone,
            synonym, speech, property, paraphrase, morph, image, eng, confusion, chs,bookId,toolkit,antonym)
            VALUES (?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        case queryWordsDetail =
        """
            SELECT * FROM T_WORDSDETAIL_INFO
            WHERE wordid IN (%@)
        """
        case fuzzyQueryWords =
        """
            SELECT * FROM T_WORDSDETAIL_INFO
            WHERE
            word LIKE '%%%@%%'
            OR
            paraphrase LIKE '%%%@%%'
            LIMIT 10
        """
        case insertMaterial =
        """
            INSERT INTO MATERIAL_INFO (path, resname, size, resid, date)
            VALUES (?, ?, ?, ?, ?)
        """
        case queryMaterial =
        """
            SELECT * FROM MATERIAL_INFO
            ORDER BY resid ASC
        """
        case deleteMaterial =
        """
            DELETE FROM MATERIAL_INFO
            WHERE date = ?
        """
        case deleteAllMaterial =
        """
            DELETE FROM MATERIAL_INFO
        """
        case insertStudyRecord =
        """
            INSERT INTO STUDYPROGRESS_INFO (recordid, bookid, unitid, questionidx, questionid, learn_status, uuid, log)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """
        case replaceStudyRecord =
        """
            REPLACE INTO STUDYPROGRESS_INFO (recordid, bookid, unitid, questionidx, questionid, learn_status, uuid, log)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """
        case queryStudyRecord =
        """
            SELECT * FROM STUDYPROGRESS_INFO
        """
        case queryStudyRecordById =
        """
            SELECT * FROM STUDYPROGRESS_INFO
            WHERE recordid = ?
        """
        case deleteStudyRecord =
        """
            DELETE FROM STUDYPROGRESS_INFO
            WHERE recordid = ?
        """
        case deleteAllStudyRecord =
        """
            DELETE FROM STUDYPROGRESS_INFO
        """
    }

}
