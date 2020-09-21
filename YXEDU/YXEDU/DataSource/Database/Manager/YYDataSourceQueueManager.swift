//
//  YYDataSourceManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import FMDB
import CocoaLumberjack

/***
 * 数据源管理类，负责创建App中所有的数据源对应的执行器
 */
class YYDataSourceQueueManager: NSObject {

    /** 全局唯一管理器 */
    public static let `default` = YYDataSourceQueueManager()

    /** 存储所有的执行器 */
    private var runners: [YYDataSourceType: FMDatabaseQueue] = [ : ]

    private override init() {
        super.init()
    }

    /**
     * 根据数据源类型，返回对应的执行器
     */
    public func createRunner(type: YYDataSourceType) -> FMDatabaseQueue {
        switch type {
        case .word:
            return try! wordRunner()
        }
    }

    /**
     * 创建数据表
     */
    public func createTable(runner: FMDatabase, sql: String) -> Bool {
        let execute = runner.executeStatements(sql)
        if !execute {
//            DDLogError(String(format: "error: execute sql %@ failed error %@", sql, runner.lastErrorMessage()))
        }
        return execute
    }

    /**
     * 关闭数据源， 当退出登录时, 更换账号时
     */
    public func close() {
        for runner in runners.values {
            runner.close()
        }
        runners.removeAll()
    }

}


//MARK: +++++++++++++++  private method
extension YYDataSourceQueueManager {
    private func wordRunner() throws -> FMDatabaseQueue {
        let filePath: String = YYDataSourceManager.dbFilePath(fileName: YYDataSourceType.word.rawValue)
        return try createRunner(type: .word, filePath: filePath, sqls: YYSQLManager.CreateTables)
    }

    /**
     * 创建数据源
     */
    private func createRunner(type: YYDataSourceType, filePath: String, sqls: [String]) throws -> FMDatabaseQueue {
        // 从缓存读取
        if let runner = runners[type] {
            return runner
        }
        let runner = FMDatabaseQueue(path: filePath)

        for sql in sqls {
            runner?.inDatabase({ (db) in
                let execute = db.executeStatements(sql)
                if !execute {
                    //                DDLogError(String(format: "error: execute sql %@ failed error %@", sql, runner.lastErrorMessage()))
                }
            })
        }

        // 添加到缓存中，不用重复创建
        runners[type] = runner

        return runner!
    }
}


