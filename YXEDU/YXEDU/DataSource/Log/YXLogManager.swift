//
//  YXLogManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import CocoaLumberjack
import ZipArchive

class YXLogManager: NSObject, DDLogFormatter {

    // MARK: ==== Request ====

    // 上传
    func report() {
        guard let fileData = self.zipLogFile() else {
            return
        }
        let request = YXLogRequest.report(file: fileData)
        YYNetworkService.default.request(YYStructResponse<YXLogModel>.self, request: request, success: { (response) in
            self.deleteZip()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: "日志上报失败")
        }
    }

    // MARK: ==== Event ====
    func addInfo() {
        self.addUserInfo()
        self.addDeviceInfo()
    }


    /// 添加用户信息
    private func addUserInfo() {
        let uuid = YXUserModel.default.uuid
        let username = YXUserModel.default.username

    }

    /// 添加设备信息
    private func addDeviceInfo() {
        let OSVersion        = YRDevice.osVersion()
        let appBuild         = YRDevice.appBuild()
        let deviceName       = UIDevice().machineName()
        let systemVersion    = UIDevice().sysVersion()
        let appVersion       = UIDevice().appVersion()
        let networkType      = UIDevice().networkType()
        let screenInch       = UIDevice().screenInch()
        let screenRecolution = UIDevice().screenResolution()
    }

    // MARK: ==== Tool ====

    ///  压缩日志文件
    private func zipLogFile() -> Data? {
        let fileLogger = DDFileLogger()
        let ziper      = ZipArchive()

        let logPathArray     = fileLogger.logFileManager.sortedLogFileNames
        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/feadbackLog.zip"

        if ziper.createZipFile2(logZipPath) {
            logPathArray.forEach { (path) in
                ziper.addFile(toZip: logDirectoryPath + "/" + path, newname: path)
            }
            DDLogDebug("创建Zip成功")
        } else {
            DDLogDebug("创建Zip失败")
        }
        ziper.closeZipFile2()
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: logZipPath)) else {
            return nil
        }
        return fileData
    }

    /// 删除Zip包
    private func deleteZip() {
        let fileLogger       = DDFileLogger()
        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/feadbackLog.zip"
        if ((try? FileManager.default.removeItem(atPath: logZipPath)) != nil) {
            DDLogDebug("删除Zip包成功")
        } else {
            DDLogDebug("删除Zip包失败")
        }
    }

    // MARK: ==== DDLogFormatter ====
    func format(message logMessage: DDLogMessage) -> String? {
        return String(format: "文件名：%@， 函数名：%@，进程ID：%@，消息内容：%@", logMessage.fileName, logMessage.function ?? "", logMessage.threadID, logMessage.message)
    }
}
