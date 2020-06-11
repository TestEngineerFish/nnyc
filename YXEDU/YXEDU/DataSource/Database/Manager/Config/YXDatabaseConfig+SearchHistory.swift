//
//  YXDatabaseConfig+SearchHistory.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
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
