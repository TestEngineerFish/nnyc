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
import MBProgressHUD

class YXLogManager: NSObject {

    @objc static let share = YXLogManager()

    // MARK: ==== Request ====

    // 上传
    @objc func report(_ showToast: Bool = false) {
        self.addInfo()
        guard let fileData = self.zipLogFile() else {
            return
        }
        if showToast {
            MBProgressHUD.showAdded(to: kWindow, animated: true)
        }
        let request = YXLogRequest.report(file: fileData)
        YYNetworkService.default.upload(YYStructResponse<YXLogModel>.self, request: request, mimeType: YXMiMeType.file.rawValue, fileName: "log", success: { (response) in
            if showToast {
                MBProgressHUD.hide(for: kWindow, animated: true)
                YXUtils.showHUD(kWindow, title: "上传完成")
            }
            self.deleteZip()
            self.deleteFile()
        }) { (error) in
            if showToast {
                MBProgressHUD.hide(for: kWindow, animated: true)
                YXUtils.showHUD(kWindow, title: "上传失败，请稍后再试")
            }
        }
    }

    // MARK: ==== Event ====
    func addInfo() {
        self.addUserInfo()
        self.addDeviceInfo()
    }

    /// 添加用户信息
    private func addUserInfo() {
        YXLog("当前用户UserID：\(YXUserModel.default.userId ?? 0)")
        YXLog("用户Token：" + (YXUserModel.default.token ?? ""))
        YXLog("当前UUID：" + (YXUserModel.default.uuid ?? ""))
        YXLog("当前用户名：" + (YXUserModel.default.userName ?? ""))
        YXLog("当前用户手机号：" + (YXUserModel.default.mobile ?? ""))
        YXLog("当前使用App版本：" + UIDevice().appVersion())
    }

    /// 添加设备信息
    private func addDeviceInfo() {
        YXLog("当前App版本：" + UIDevice().appVersion())
        YXLog("当前App Build版本：" + YRDevice.appBuild())
        YXLog("当前设备名称：" + UIDevice().machineName())
        YXLog("当前系统版本：" + UIDevice().sysVersion())
        YXLog("当前网络环境：" + UIDevice().networkType())
        YXLog("当前屏幕英寸：" + UIDevice().screenInch())
        YXLog("当前屏幕分辨率：" + UIDevice().screenResolution())
    }

    // MARK: ==== Tool ====

    ///  压缩日志文件
    private func zipLogFile() -> Data? {
        let fileLogger    = DDFileLogger()
        let requestLogger = YXOCLog.shared()?.loggerFoRequest
        let eventLogger   = YXOCLog.shared()?.loggerForEvent
        
        let logZiper         = ZipArchive()
        let requestZiper     = ZipArchive()
        let eventZiper       = ZipArchive()
        let wordSQLiteZiper  = ZipArchive()

        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/Log.zip"
        
        let requestLogList   = requestLogger?.logFileManager.sortedLogFileNames
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventLogList     = eventLogger?.logFileManager.sortedLogFileNames
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""
        let eventZipPath     = eventDirectory + "/Event.zip"

        let wordSQLitePath: String = {
            let documentPath = NSHomeDirectory() + "/Documents/"
            if !FileManager.default.fileExists(atPath: documentPath){
                try? FileManager.default.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            return documentPath
        }()
        let wordSQLiteZipPath = wordSQLitePath + "WordSQL.zip"
        
        YXLog("++++++++++++++++")
        YXLog(logDirectoryPath)
        if requestZiper.createZipFile2(requestZipPath) {
            requestLogList?.forEach({ (name) in
                requestZiper.addFile(toZip: requestDirectory + "/" + name, newname: name)
            })
            YXLog("创建Request Zip成功")
        } else {
            YXLog("创建Request Zip失败")
        }
        requestZiper.closeZipFile2()
        
        if eventZiper.createZipFile2(eventZipPath) {
            eventLogList?.forEach({ (name) in
                eventZiper.addFile(toZip: eventDirectory + "/" + name, newname: name)
            })
            YXLog("创建Event Zip成功")
        } else {
            YXLog("创建Evnet Zip失败")
        }
        eventZiper.closeZipFile2()

        if wordSQLiteZiper.createZipFile2(wordSQLiteZipPath) {
            let sqlPath = YYDataSourceManager.dbFilePath(fileName: YYDataSourceType.word.rawValue)
            wordSQLiteZiper.addFile(toZip: sqlPath, newname: YYDataSourceType.word.rawValue)
            YXLog("创建Word SQLite Zip成功")
        } else {
            YXLog("创建Word SQLite Zip失败")
        }
        wordSQLiteZiper.closeZipFile2()
        
        guard let requestZipData = try? Data(contentsOf: URL(fileURLWithPath: requestZipPath)), let eventZipData = try? Data(contentsOf: URL(fileURLWithPath: eventZipPath)), let wordSQLiteZipData = try? Data(contentsOf: URL(fileURLWithPath: wordSQLiteZipPath)) else {
            return nil
        }
        if logZiper.createZipFile2(logZipPath) {
            logZiper.addData(toZip: requestZipData, fileAttributes: [:], newname: "Request.zip")
            logZiper.addData(toZip: eventZipData, fileAttributes: [:], newname: "Event.zip")
            logZiper.addData(toZip: wordSQLiteZipData, fileAttributes: [:], newname: "WordSQL.zip")
            YXLog("创建Log Zip成功")
        } else {
            YXLog("创建Log Zip失败")
        }
        logZiper.closeZipFile2()
        guard let logZipData = try? Data(contentsOf: URL(fileURLWithPath: logZipPath))else {
            return nil
        }
        return logZipData
    }

    /// 删除Zip包
    private func deleteZip() {
        let fileLogger    = DDFileLogger()
        let requestLogger = YXOCLog.shared()?.loggerFoRequest
        let eventLogger   = YXOCLog.shared()?.loggerForEvent
        
        let logDirectory     = fileLogger.logFileManager.logsDirectory
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""
        
        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventZipPath     = eventDirectory + "/Event.zip"
        let logZipPath       = logDirectory + "/Log.zip"
        let wordSQLitePath: String = {
            let documentPath = NSHomeDirectory() + "/Documents/"
            if !FileManager.default.fileExists(atPath: documentPath){
                try? FileManager.default.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            return documentPath
        }()
        let wordSQLiteZipPath = wordSQLitePath + "WordSQL.zip"

        if ((try? FileManager.default.removeItem(atPath: requestZipPath)) != nil) {
            YXLog("删除Request Zip包成功")
        } else {
            YXLog("删除Reqeust Zip包失败")
        }
        
        if ((try? FileManager.default.removeItem(atPath: eventZipPath)) != nil) {
            YXLog("删除Event Zip包成功")
        } else {
            YXLog("删除Evnet Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: wordSQLiteZipPath)) != nil) {
            YXLog("删除Word SQLite Zip包成功")
        } else {
            YXLog("删除Word SQLite Zip包失败")
        }
        
        if ((try? FileManager.default.removeItem(atPath: logZipPath)) != nil) {
            YXLog("删除Log Zip包成功")
        } else {
            YXLog("删除Log Zip包失败")
        }
    }
    
    /// 删除日志文件
    private func deleteFile() {
        let requestLogger = YXOCLog.shared()?.loggerFoRequest
        let eventLogger   = YXOCLog.shared()?.loggerForEvent
        
        let requestLogFileList = requestLogger?.logFileManager.sortedLogFilePaths ?? []
        let eventLogFileList   = eventLogger?.logFileManager.sortedLogFilePaths ?? []
        
        requestLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
                print("删除Request日志成功")
            } else {
                print("删除Request日志失败")
            }
        }
        eventLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
                print("删除Even日志成功")
            } else {
                print("删除Event日志失败")
            }
        }
    }
}
