//
//  YXFileManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/31.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

enum YXFileNameEnum: String {
    /// 包含首页Tab所有数据
    case home      = "home"
    /// 包含复习Tab所有数据
    case review    = "review"
    /// 包含挑战Tab所有数据
    case challenge = "challenge"
    /// 包含我的Tab所有数据
    case mine_userInfo = "mine_userInfo" // 个人信息
    case mine_badge    = "mine_badge"    // 徽章
    case mine_integral = "mine_integral" // 积分
    /// 主流程学习记录
    case mainStudy     = "mainStudy"
    /// 智能复习
    case aiReview      = "aiReview"
    /// 听写练习
    case listenReview  = "listenReview"
    /// 计划复习
    case planReview    = "planReview"
    /// 错词本-抽查复习
    case wrongReview   = "wrongReview"

    enum YXFileTypeEnum: String {
        case tab   = "json"
        case study = "txt"
    }

    /// 类型分组
    /// - Returns: 返回文件类型对应的组别
    func getGroup() -> YXFileTypeEnum {
        switch self {
        case .home, .review, .challenge, .mine_userInfo, .mine_badge, .mine_integral:
            return .tab
        case .mainStudy, .aiReview, .listenReview, .planReview, .wrongReview:
            return .study
        }
    }
}



struct YXFileManager {
    public static let share = YXFileManager()

    // MARK: ==== 写入 =====

    /// 保存Json到文件
    /// - Parameters:
    ///   - json: JSON内容
    ///   - type: 文件名
    func saveJsonToFile(with json: String, type: YXFileNameEnum) {
        let filePath: String = {
            switch type.getGroup() {
            case .tab:
                let path = self.getJsonPath()
                return String(format: "%@/%@.json", path, type.rawValue)
            case .study:
                let path = self.getStudyPath()
                return String(format: "%@/%@.txt", path, type.rawValue)
            }
        }()
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        guard let fileHandle = FileHandle(forWritingAtPath: filePath), let jsonData = json.data(using: .utf8) else {
            return
        }
        YXRequestLog("存储\(type.rawValue)的\(type.getGroup().rawValue)文件成功，内容：", json)
        fileHandle.write(jsonData)
    }

    // MARK: ==== 读取 =====

    /// 获取JSON内容
    /// - Parameter type: 存储的文件名
    /// - Returns: 存储的JSON内容，如果不存在则返回空
    func getJsonFromFile(type: YXFileNameEnum) -> String? {
        let filePath: String = {
            switch type.getGroup() {
            case .tab:
                let path = self.getJsonPath()
                return String(format: "%@/%@.json", path, type.rawValue)
            case .study:
                let path = self.getStudyPath()
                return String(format: "%@/%@.txt", path, type.rawValue)
            }
        }()
        var json: String?
        do {
            json = try String(contentsOfFile: filePath, encoding: .utf8)
        } catch {
            YXLog("解析\(type.rawValue)的JSON失败，error: ", error.localizedDescription)
            return json
        }
        return json
    }

    // MARK: ---- Tools ----

    /// 获取JSON文件路径
    /// - Returns: 文件路径
    private func getJsonPath() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if documentPath == nil {
            documentPath = NSHomeDirectory() + "/Documents"
        }
        let jsonPath = documentPath! + "/JSON_" + (YXConfigure.shared().uuid ?? "") + "/"
        if !FileManager.default.fileExists(atPath: jsonPath) {
            try? FileManager.default.createDirectory(atPath: jsonPath, withIntermediateDirectories: true, attributes: nil)
        }
        return jsonPath
    }

    /// 获取学习缓存文件路径
    /// - Returns: 文件路径
    func getStudyPath() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if documentPath == nil {
            documentPath = NSHomeDirectory() + "/Documents"
        }
        let textPath = documentPath! + "/Study_" + (YXConfigure.shared().uuid ?? "") + "/"
        if !FileManager.default.fileExists(atPath: textPath) {
            try? FileManager.default.createDirectory(atPath: textPath, withIntermediateDirectories: true, attributes: nil)
        }
        return textPath
    }

    /// 清除指定路径下的文件
    /// - Parameter path: 指定路径
    /// - Returns: 删除是否成功
    @discardableResult
    func clearFile(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            YXLog("删除文件失败，路径：\(path)， 错误：\(error)")
            return false
        }
    }

    /// 清除学习记录缓存
    func clearStudyCache() {
        self.clearFile(path: self.getStudyPath())
        YXExcerciseProgressManager.clearAllKeyCache()
    }

    func saveFile(to path: String) {
        if FileManager.default.fileExists(atPath: path) {
            self.clearFile(path: path)
        }
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
}
