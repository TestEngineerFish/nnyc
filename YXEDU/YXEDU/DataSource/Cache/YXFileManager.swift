//
//  YXFileManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/31.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

enum YXFileNameEnum: String {
    /// 包含复习主页所有数据
    case review = "review"
}

struct YXFileManager {
    public static let share = YXFileManager()

    // MARK: ==== 写入 =====

    /// 保存Json到文件
    /// - Parameters:
    ///   - json: JSON内容
    ///   - type: 文件名
    func saveJsonToFile(with json: String, type: YXFileNameEnum) {
        let jsonPath = self.getJsonPath()
        let filePath = String(format: "%@/%@.json", jsonPath, type.rawValue)
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        guard let fileHandle = FileHandle(forWritingAtPath: filePath), let jsonData = json.data(using: .utf8) else {
            return
        }
        YXLog("存储\(type.rawValue)的JSON文件，JSON：", json)
        fileHandle.write(jsonData)
    }

    // MARK: ==== 读取 =====

    /// 获取JSON内容
    /// - Parameter type: 存储的文件名
    /// - Returns: 存储的JSON内容，如果不存在则返回空
    func getJsonFromFile(type: YXFileNameEnum) -> String? {
        let jsonPath = self.getJsonPath()
        let filePath = String(format: "%@/%@.json", jsonPath, type.rawValue)
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
        let jsonPath = documentPath! + "/JSON"
        if !FileManager.default.fileExists(atPath: jsonPath) {
            try? FileManager.default.createDirectory(atPath: jsonPath, withIntermediateDirectories: true, attributes: nil)
        }
        return jsonPath
    }

}
