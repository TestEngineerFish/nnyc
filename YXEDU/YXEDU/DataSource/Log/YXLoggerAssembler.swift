//
//  YXLoggerAssembler.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXLoggerAssembler {
    
    static func createFileLogger(type: YXFolderNameType) -> DDFileLogger {
        let customLogger = YXFileLogger(type: type)
        customLogger.rollingFrequency   = 60 * 60 * 24
        customLogger.maximumFileSize    = 1024 * 1024 * 1
        customLogger.doNotReuseLogFiles = true
        customLogger.logFileManager.maximumNumberOfLogFiles = 5
        return customLogger
    }
}
