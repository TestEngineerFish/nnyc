//
//  YXFileLogger.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum YXFolderNameType: String {
    case request = "15"
    case action  = "100"
}

class YXFileLogger: DDFileLogger {
    
    init(name: YXFolderNameType) {
        let logsDirectory  = DDFileLogger().logFileManager.logsDirectory + "/" + name.rawValue
        let logFileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory)
        super.init(logFileManager: logFileManager, completionQueue: nil)
    }
}
