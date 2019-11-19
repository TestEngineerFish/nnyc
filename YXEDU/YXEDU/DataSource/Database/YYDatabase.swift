//
//  YYDatabase.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import FMDB


/**
 * 数据源协议，定义多个不同的数据库执行器
 */
protocol YYDataSource {
    
    /// 普通数据库执行器
    var normalRunner: FMDatabaseQueue { get }
        
    /// 词书数据可执行器
    var wordRunnerQueue: FMDatabaseQueue { get }
    
    /// 词书数据可执行器
//    var wordRunner: FMDatabaseQueue { get }
    
}


/**
 * 数据源默认实现，提供各种数据库对应的执行器
 * 考虑到部分模块使用的第三方库，可能需要在第三方模块中使用当前的执行器
 */
extension YYDataSource {
    var normalRunner: FMDatabaseQueue {
        return YYDataSourceManager.default.createRunner(type: .normal)
    }
    
    var wordRunnerQueue: FMDatabaseQueue {
        return YYDataSourceManager.default.createRunner(type: .word)
    }
}


/**
 * 数据库基类，提供各种数据库执行器，子类应该继承自该类【非必须继承】
 */
public class YYDatabase: NSObject, YYDataSource {

}
