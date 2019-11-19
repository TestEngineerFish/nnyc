//
//  YXExcerciseProgressManager.swift
//  
//
//  Created by sunwu on 2019/10/28.
//

import UIKit

/// 练习进度管理器
class YXExcerciseProgressManager: NSObject {
    
    enum LocalKey: String {
        case new = "new.txt"
        case review = "review.txt"
        
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
    }
    
    /// 是否存在学完，未上报的关卡
    class func isExistUnReport() -> Bool {
        if let result = YYCache.object(forKey: LocalKey.report.rawValue) as? Bool, result == false {
            return true
        }
        return false
    }
    
    /// 是否存在未学完的关卡
    class func isExistUnCompletion() -> Bool {
        if let result = YYCache.object(forKey: LocalKey.completion.rawValue) as? Bool, result == false {
            return true
        }
        return false
    }
    
    /// 跟新练习进度
//    class func updateProgress(exerciseModel: YXWordExerciseModel) {
//
//    }
    class func initStatus() {
        YYCache.set(false, forKey: LocalKey.completion.rawValue)
    }
    
    class func updateNewWordProgress(exerciseModels: [YXWordExerciseModel]) {
        let str = exerciseModels.toJSONString()
        let filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.new.rawValue)
        try? str?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    
    class func updateReviewWordProgress(exerciseModels: [YXWordExerciseModel]) {
        let str = exerciseModels.toJSONString()
        let filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.rawValue)
        try? str?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
        
    class func localExerciseModels() -> ([YXWordExerciseModel], [YXWordExerciseModel]) {
        var filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.new.rawValue)
        var new: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            new = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.rawValue)
        var review: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            review = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        return (new ?? [], review ?? [])
    }
    
    
    class func clearExerciseModels() {
        var filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.rawValue)
        _ = YYFileManager.share.clearFile(path: filePath)
        
        filePath = YYDataSourceManager.dbFilePath(fileName: LocalKey.review.rawValue)
        _ = YYFileManager.share.clearFile(path: filePath)
        
        YYCache.remove(forKey: LocalKey.report.rawValue)
    }
    
    /// 对错判断
//    class func isRight() -> Bool {
//         return false
//    }
    
    /// 当前关卡是否学完
    class func isCompletion() -> Bool {
        return false
    }
    
}
