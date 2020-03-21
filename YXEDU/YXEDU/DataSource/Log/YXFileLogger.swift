//
//  YXFileLogger.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum YXFolderNameType: Int {
    case request = 1
    case action  = 2
}

class YXFileLogger: DDFileLogger {
    
    init(type: YXFolderNameType) {
        let logsDirectory  = DDFileLogger().logFileManager.logsDirectory + "/\(type.rawValue)"
        let logFileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory)
        super.init(logFileManager: logFileManager, completionQueue: nil)
        let logFormatter = YXContextWhitelistFilterLogFormatter()
        if type == .action {
            logFormatter?.add(toWhitelist: type.rawValue)
        } else {
            logFormatter?.add(toWhitelist: type.rawValue)
        }
        self.logFormatter = logFormatter
    }
}
