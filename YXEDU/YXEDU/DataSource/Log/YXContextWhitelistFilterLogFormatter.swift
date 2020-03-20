//
//  YXContextWhitelistFilterLogFormatter.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import CocoaLumberjack

class YXContextWhitelistFilterLogFormatter: DDContextWhitelistFilterLogFormatter {
    
    override func format(message:DDLogMessage) -> String {
//        NSString *path = [NSString stringWithCString:logMessage.file.UTF8String encoding:NSASCIIStringEncoding];
//        NSString *fileName = [path lastPathComponent];
//        NSString *functionName = [NSString stringWithCString:logMessage.function.UTF8String encoding:NSASCIIStringEncoding];
//        NSString *level = [self _logLevelWithFlag:logMessage->_flag];
//        return [NSString stringWithFormat:@"[%@]%@-%@(%lu): %@",level, fileName, functionName, (unsigned long)logMessage.line, logMessage.message];
//        let path = String(cString: message.file.utf8CString, encoding: .ascii)
//        String(cString: <#T##UnsafePointer<CChar>#>, encoding: <#T##String.Encoding#>)
//        message.file.
        return message.message
    }
}
