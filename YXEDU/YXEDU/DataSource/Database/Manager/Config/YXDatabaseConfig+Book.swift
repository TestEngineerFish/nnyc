//
//  YXDatabaseConfig+Book.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    enum BookSQL: String {
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

        case selectBookIdList =
        """
        SELECT * FROM book
        """

        case deleteAllBooks =
        """
        DELETE FROM book
        """
    }
}
