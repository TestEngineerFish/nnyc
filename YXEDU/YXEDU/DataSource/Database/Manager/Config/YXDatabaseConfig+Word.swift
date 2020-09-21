//
//  YXDatabaseConfig+Word.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    enum WordSQL: String {
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

        case deleteWordById =
        """
        DELETE FROM word
        WHERE wordId = ?
        """

        case deleteWord =
        """
        DELETE FROM word
        WHERE bookId = ?
        """

        case deleteAllWords =
        """
        DELETE FROM word
        """
    }

}
