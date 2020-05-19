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
    
    // 创建词书数据表
    static let CreateWordTables: [String] = {
        var sqlArray = [CreateWordTableSQLs.bookTable.rawValue,
                        CreateWordTableSQLs.wordTable.rawValue,
                        CreateWordTableSQLs.searchHistoryTable.rawValue]
        if YYCache.object(forKey: "updateDatabase") as? Bool ?? true {
            sqlArray.insert(DeleteTableSQLs.bookTable.rawValue, at: 0)
            sqlArray.insert(DeleteTableSQLs.wordTable.rawValue, at: 0)
            sqlArray.insert(DeleteTableSQLs.searchHistoryTable.rawValue, at: 0)
        }
        YYCache.set(false, forKey: "updateDatabase")
        return sqlArray
    }()
    
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

    enum DeleteTableSQLs: String {
        case bookTable = "DROP TABLE IF EXISTS book;"
        case wordTable = "DROP TABLE IF EXISTS word;"
        case searchHistoryTable = "DROP TABLE IF EXISTS search_history_table;"
    }
    
    enum  CreateWordTableSQLs: String {
        case bookTable =
        """
        CREATE TABLE IF NOT EXISTS book (
        bookId integer PRIMARY KEY NOT NULL,
        bookName text,
        bookSource text,
        bookHash char(64),
        gradeId integer,
        gradeType integer
        )
        """
        
        case wordTable =
        """
        CREATE TABLE IF NOT EXISTS word (
        id integer primary key,
        wordId integer NOT NULL,
        word char(64),
        partOfSpeechAndMeanings text,
        imageUrl varchar(512),
        englishPhoneticSymbol char(128),
        americanPhoneticSymbol char(128),
        englishPronunciation varchar(128),
        americanPronunciation varchar(128),
        deformations text,
        examples text,
        fixedMatchs text,
        commonPhrases text,
        wordAnalysis text,
        detailedSyntaxs text,
        synonyms text,
        antonyms text,
        gradeId integer,
        gardeType integer,
        bookId integer,
        unitId integer,
        unitName varchar(512),
        isExtensionUnit integer
        )
        """
        
        case searchHistoryTable =
        """
        CREATE TABLE IF NOT EXISTS search_history_table (
        id integer primary key,
        wordId integer NOT NULL,
        word char(64),
        partOfSpeechAndMeanings text,
        englishPhoneticSymbol char(128),
        americanPhoneticSymbol char(128),
        englishPronunciation varchar(128),
        americanPronunciation varchar(128),
        isComplexWord integer
        );
        """
    }

    enum WordBookSQL: String {
        case insertBook =
        """
        INSERT INTO book
        (bookId, bookName, bookSource, bookHash, gradeId, gradeType)
        VALUES (?, ?, ?, ?, ?, ?)
        """
        
        case selectBook =
        """
        SELECT * FROM book
        WHERE bookId = ?
        """
        
        case deleteBook =
        """
        DELETE FROM book
        WHERE bookId = ?
        """
        
        case insertWord =
        """
        INSERT INTO word
        (wordId, word, partOfSpeechAndMeanings, imageUrl, englishPhoneticSymbol,
        americanPhoneticSymbol, englishPronunciation, americanPronunciation, deformations, examples,
        fixedMatchs, commonPhrases, wordAnalysis, detailedSyntaxs, synonyms,
        antonyms, gradeId, gardeType, bookId, unitId,
        unitName, isExtensionUnit)
        VALUES (?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?,
        ?, ?)
        """
        
        case selectWord =
        """
        SELECT * FROM word
        WHERE wordId = ?
        """
        
        case selectBookIdList =
        """
        SELECT * FROM book
        """
        
        case selectWordByBookIdAndWordId =
        """
        SELECT * FROM word
        WHERE bookId = ? and wordId = ?
        """
        
        case selectWordByUnitId =
        """
        SELECT * FROM word
        WHERE unitId = ?
        """
        
        case selectWordByBookId =
        """
        SELECT * FROM word
        WHERE bookId = ?
        """
        
        case deleteWord =
        """
        DELETE FROM word
        WHERE bookId = ?
        """
    }

    
    
    enum SearchHistory: String {
        case selectWord =
        """
        SELECT * FROM search_history_table
        """
        
        case insertWord =
        """
        INSERT INTO search_history_table
        (wordId, word, partOfSpeechAndMeanings, englishPhoneticSymbol, americanPhoneticSymbol,
        englishPronunciation, americanPronunciation, isComplexWord)
        VALUES (?, ?, ?, ?, ?,
        ?, ?, ?)
        """
        
        case deleteWord =
        """
        delete from search_history_table
        """
    }
}
