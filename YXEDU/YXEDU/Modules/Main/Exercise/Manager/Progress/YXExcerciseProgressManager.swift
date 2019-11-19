//
//  YXExcerciseProgressManager.swift
//  
//
//  Created by sunwu on 2019/10/28.
//

import UIKit

/// 练习进度管理器
class YXExcerciseProgressManager: NSObject {
    
    /// 本地存储Key
    enum LocalKey: String {
        case new = "new.txt"
        case review = "review.txt"
        
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
        
        var key: String {
            return "\(YXUserModel.default.uuid ?? "")_" + self.rawValue
        }
    }
    
    /// 关卡是否上报
    class func isReport() -> Bool {
        if let _ = YYCache.object(forKey: LocalKey.report.key) as? Bool {
            return false
        }
        return true
    }
    
    /// 关卡是否学完
    class func isCompletion() -> Bool {
        if let _ = YYCache.object(forKey: LocalKey.completion.key) as? Bool {
            return false
        }
        return true
    }
    
    
    /// 跟新练习进度
    /// - Parameters:
    ///   - newExerciseModel: 新学
    ///   - reviewExerciseModel: 复习
    class func updateProgress(newExerciseModel: [YXWordExerciseModel], reviewExerciseModel: [YXWordExerciseModel]) {
        self.saveToLocal(exerciseModels: newExerciseModel, key: .new)
        self.saveToLocal(exerciseModels: reviewExerciseModel, key: .review)
    }
    
    
    class func initProgressStatus() {
        YYCache.set(false, forKey: LocalKey.completion.key)
    }
    

    /// 本地未学完的数据
    class func localExerciseModels() -> ([YXWordExerciseModel], [YXWordExerciseModel]) {
        var filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.new.key)
        var new: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            new = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.key)
        var review: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            review = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        return (new ?? [], review ?? [])
    }
    
    
    /// 完成答题
    class func completionExercise() {
        YYCache.remove(forKey: LocalKey.completion.key)        
        YYCache.set(false, forKey: LocalKey.report.key)
    }
    
    
    /// 完成上报
    class func completionReport() {
        YYCache.remove(forKey: LocalKey.report.key)
        
        var filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.new.key)
        var result = YYFileManager.share.clearFile(path: filePath)
        print("新学数据完成，本地数据删除：", result )
        
        filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.key)
        result = YYFileManager.share.clearFile(path: filePath)
        print("复习数据完成，本地数据删除：", result )
    }
    
    /// 更新进度
    /// - Parameter exerciseModels: 数据
    private class func saveToLocal(exerciseModels: [YXWordExerciseModel], key: LocalKey) {
        let str = exerciseModels.toJSONString()
        let filePath = YYDataSourceManager.dbFilePath(fileName: key.key)
        try? str?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
}
