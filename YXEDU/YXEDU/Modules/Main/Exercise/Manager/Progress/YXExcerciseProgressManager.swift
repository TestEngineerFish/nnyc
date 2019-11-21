//
//  YXExcerciseProgressManager.swift
//  
//
//  Created by sunwu on 2019/10/28.
//

import UIKit

/// 练习进度管理器
class YXExcerciseProgressManager: NSObject {
    
    public var bookId: Int = 0
    public var unitId: Int = 0
    
    
    /// 本地存储Key
    enum LocalKey: String {
        case new = "new.txt"
        case review = "review.txt"
        
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
    }
    
    
    private func key(_ key: LocalKey) -> String {
        return "\(bookId)_\(unitId)_\(YXUserModel.default.uuid ?? "")_" + key.rawValue
    }
    
    
    /// 关卡是否上报
    func isReport() -> Bool {
        if let _ = YYCache.object(forKey: key(.report)) as? Bool {
            return false
        }
        return true
    }
    
    /// 关卡是否学完
    func isCompletion() -> Bool {
        if let _ = YYCache.object(forKey: key(.completion)) as? Bool {
            return false
        }
        return true
    }
    
    class func isCompletion(bookId: Int, unitId: Int) -> Bool {
        let manager = YXExcerciseProgressManager()
        manager.bookId = bookId
        manager.unitId = unitId
        return manager.isCompletion()
    }
    
    
    /// 跟新练习进度
    /// - Parameters:
    ///   - newExerciseModel: 新学
    ///   - reviewExerciseModel: 复习
    func updateProgress(newExerciseModel: [YXWordExerciseModel], reviewExerciseModel: [YXWordExerciseModel]) {
        self.saveToLocal(exerciseModels: newExerciseModel, localKey: .new)
        self.saveToLocal(exerciseModels: reviewExerciseModel, localKey: .review)
    }
    
    
    func initProgressStatus() {
        YYCache.set(false, forKey: key(.completion))
    }
    

    /// 本地未学完的数据
    func localExerciseModels() -> ([YXWordExerciseModel], [YXWordExerciseModel]) {
        var filePath = YYDataSourceManager.dbFilePath(fileName: key(.new))
        var new: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            new = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: key(.review))
        var review: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            review = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        return (new ?? [], review ?? [])
    }
    
    
    /// 完成答题
    func completionExercise() {
        YYCache.remove(forKey: key(.completion))
        YYCache.set(false, forKey: key(.report))
    }
    
    
    /// 完成上报
    func completionReport() {
        YYCache.remove(forKey: key(.report))
        
        var filePath = YYDataSourceManager.dbFilePath(fileName: key(.new))
        var result = YYFileManager.share.clearFile(path: filePath)
        print("新学数据完成，本地数据删除：", result )

        filePath = YYDataSourceManager.dbFilePath(fileName: key(.review))
        result = YYFileManager.share.clearFile(path: filePath)
        print("复习数据完成，本地数据删除：", result )
    }
    
    /// 更新进度
    /// - Parameter exerciseModels: 数据
    func saveToLocal(exerciseModels: [YXWordExerciseModel], localKey: LocalKey) {
        let str = exerciseModels.toJSONString()
        let filePath = YYDataSourceManager.dbFilePath(fileName: key(localKey))
        try? str?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
}
