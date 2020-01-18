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

    static let share = YXLogManager()

    // MARK: ==== Request ====

    // 上传
    func report() {
        guard let fileData = self.zipLogFile() else {
            return
        }
        let request = YXLogRequest.report(file: fileData)
        YYNetworkService.default.upload(YYStructResponse<YXLogModel>.self, request: request, success: { (response) in
            YXUtils.showHUD(kWindow, title: "上报成功")
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
        DDLogInfo("当前UUID：" + (YXUserModel.default.uuid ?? ""))
        DDLogInfo("当前用户名：" + (YXUserModel.default.username ?? ""))
        DDLogInfo("当前用户手机号：" + (YXConfigure.shared()?.mobile ?? ""))
    }

    /// 添加设备信息
    private func addDeviceInfo() {
        DDLogInfo("当前App版本：" + UIDevice().appVersion())
        DDLogInfo("当前App Build版本：" + YRDevice.appBuild())
        DDLogInfo("当前设备名称：" + UIDevice().machineName())
        DDLogInfo("当前系统版本：" + UIDevice().sysVersion())
        DDLogInfo("当前网络环境：" + UIDevice().networkType())
        DDLogInfo("当前屏幕英寸：" + UIDevice().screenInch())
        DDLogInfo("当前屏幕分辨率：" + UIDevice().screenResolution())
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
            DDLogInfo("创建Zip成功")
        } else {
            DDLogInfo("创建Zip失败")
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
            DDLogInfo("删除Zip包成功")
        } else {
            DDLogInfo("删除Zip包失败")
        }
    }

    // MARK: ==== DDLogFormatter ====
    func format(message logMessage: DDLogMessage) -> String? {
        return String(format: "文件名：%@， 函数名：%@，进程ID：%@，消息内容：%@", logMessage.fileName, logMessage.function ?? "", logMessage.threadID, logMessage.message)
    }
}
