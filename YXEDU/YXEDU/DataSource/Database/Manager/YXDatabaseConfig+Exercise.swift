//
//  YXDatabaseConfig+Exercise.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YYSQLManager {
    // 创建学习训练数据表
    static let CreateExerciseTables: [String] = [CreateNormalTableSQLs.CreateMaterialTable.rawValue,
                                               CreateNormalTableSQLs.CreateStudyRecordTable.rawValue,
                                               CreateNormalTableSQLs.CreateWordsDetailTable.rawValue,
                                               CreateNormalTableSQLs.CreateBookMaterialTable.rawValue]
    
    
    
    enum  CreateExerciseTableSQLs: String {
        case exerciseTable =
        """
        CREATE TABLE IF NOT EXISTS exercise_table (id INTEGER PRIMARY KEY autoincrement, path TEXT NOT NULL, resname TEXT NOT NULL, size TEXT NOT NULL, resid TEXT NOT NULL, date DATE NOT NULL, UNIQUE(resid))
        """
        
        case taskTable =
        """
        CREATE TABLE IF NOT EXISTS task_table (id INTEGER PRIMARY KEY autoincrement, bookid TEXT NOT NULL, unitid TEXT NOT NULL, questionidx TEXT NOT NULL, questionid TEXT NOT NULL, uuid TEXT NOT NULL, learn_status TEXT NOT NULL, recordid TEXT NOT NULL, log TEXT NOT NULL, UNIQUE(recordid))
        """
    }
    
    
    // MARK: Update & Select
    enum ExerciseSQL: String {
        case addExercise =
        """
        SELECT * FROM T_BOOKMATERIAL
        WHERE bookId IN (%@)
        """
        case addTask =
        """
        SELECT * FROM T_BOOKMATERIAL
        """
    }
}
