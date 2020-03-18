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
    case request = "Request"
    case action  = "Action"
}

class YXFileLogger: DDFileLogger {
    
//    init(name: YXFolderNameType) {
//        NSString *logsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%ld",(long)flag]];
//        CSFileManagerDefault *defaultLogFileManager = [[CSFileManagerDefault alloc] initWithLogsDirectory:logsDirectory fileName:@"cslogger"];
//        return [self initWithLogFileManager:defaultLogFileManager];
//        let logsDirectory = DDFileLogger().logFileManager.logsDirectory + "/" + name.rawValue
//        let defaultLogFileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory)
//        super.init(logFileManager: defaultLogFileManager)
//    }
}
