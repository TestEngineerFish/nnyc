//
//  YXDataSourceManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import FMDB
import CocoaLumberjack

enum YYDataSourceType: String {
    /** App内通用数据库 */
    case normal = "YX.sqlite"
    case word = "YX_Word.sqlite"
}


enum YYSQLError: Error {
    case CreateDatabaseError, CreateTableError
    case ExecuteSQLError
}


class YYDataSourceManager: NSObject {
    
    /** 全局唯一管理器 */
    public static let `default` = YYDataSourceManager()
    
    /** 存储所有的执行器 */
    private var runners: [YYDataSourceType: FMDatabase] = [ : ]
    
    private override init() {
        super.init()
    }
    
    /**
     * 根据数据源类型，返回对应的执行器
     */
    public func createRunner(type: YYDataSourceType) -> FMDatabase {
        switch type {
        case .normal:
            return try! normalRunner()
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
            DDLogError(String(format: "error: execute sql %@ failed error %@", sql, runner.lastErrorMessage()))
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
extension YYDataSourceManager {
    
    private func normalRunner() throws -> FMDatabase {
        let filePath: String = YYDataSourceManager.dbFilePath(fileName: YYDataSourceType.normal.rawValue)
        return try createRunner(type: .normal, filePath: filePath, sqls: YYSQLManager.CreateNormalTables)
    }
    
    private func wordRunner() throws -> FMDatabase {
        let filePath: String = YYDataSourceManager.dbFilePath(fileName: YYDataSourceType.word.rawValue)
        return try createRunner(type: .word, filePath: filePath, sqls: YYSQLManager.CreateWordTables)
    }
    
    /**
     * 创建数据源
     */
    private func createRunner(type: YYDataSourceType, filePath: String, sqls: [String]) throws -> FMDatabase {
        // 从缓存读取
        if let runner = runners[type] {
            return runner
        }
        YXFileManager.share.moveToNewDataSourcePath()
        let runner = FMDatabase(path: filePath)
        guard runner.open() else {
            DDLogError(String(format:"error open database failed %@", filePath))
            throw YYSQLError.CreateDatabaseError
        }
        
        for sql in sqls {
            let execute = runner.executeStatements(sql)
            if !execute {
                DDLogError(String(format: "error: execute sql %@ failed error %@", sql, runner.lastErrorMessage()))
            }
        }
        
        // 添加到缓存中，不用重复创建
        runners[type] = runner
        
        return runner
    }
    


}



extension YYDataSourceManager {
    class func dbFilePath(fileName: String) -> String {
        let uuid = YXUserModel.default.uuid ?? "temp"
        let documentPath = NSHomeDirectory() + "/Documents/" + uuid + "/"
        if !FileManager.default.fileExists(atPath: documentPath){
            do{
                try FileManager.default.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
//                DDLogError("Create DB Directory Fail")
            }
        }
        return documentPath.appending(fileName)
    }

}
