//
//  YXExcerciseProgressManager.swift
//  
//
//  Created by sunwu on 2019/10/28.
//

import UIKit
import ObjectMapper

/// 练习进度管理器
class YXExcerciseProgressManager: NSObject {
    
    public var bookId: Int = 0
    public var unitId: Int = 0
    
    
    /// 本地存储Key
    enum LocalKey: String {
        case new = "new.txt"
        case review = "review.txt"
        case current = "current.txt"
        
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
        case reviewWordIds = "Review_Word_Id_List"
    
        case score = "Exercise_Score"
        case skipNewWord = "Skip_New_Word"
    }
    
    
    private func key(_ key: LocalKey) -> String {
        return "\(bookId)_\(unitId)_\(YXConfigure.shared().uuid ?? "")_" + key.rawValue
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
    
    
    /// 待复习的单词数
    func reviewWordIds() -> [Int] {
        if let list = YYCache.object(forKey: key(.reviewWordIds)) as? [Int] {
            return list
        }
        return []
    }
    
    
    class func isReport(bookId: Int, unitId: Int) -> Bool {
        let manager = YXExcerciseProgressManager()
        manager.bookId = bookId
        manager.unitId = unitId
        return manager.isReport()
    }
    
    
    class func isCompletion(bookId: Int, unitId: Int) -> Bool {
        let manager = YXExcerciseProgressManager()
        manager.bookId = bookId
        manager.unitId = unitId
        return manager.isCompletion()
    }
    
    func isSkipNewWord() -> Bool {
        return YYCache.object(forKey: key(.skipNewWord)) != nil
    }
    
    func setSkipNewWord() {
        YYCache.set(true, forKey: key(.skipNewWord))
    }
    
    
    /// 跟新练习进度
    /// - Parameters:
    ///   - newExerciseModel: 新学
    ///   - reviewExerciseModel: 复习
    func updateProgress(newWordArray: [YXWordExerciseModel], reviewWordArray: [YXWordStepsModel]) {
        self.saveToLocal(jsonString: newWordArray.toJSONString(), localKey: .new)
        self.saveToLocal(jsonString: reviewWordArray.toJSONString(), localKey: .review)
    }
    
    
    func updateCurrentExercisesProgress(currentExerciseArray: [YXWordExerciseModel]) {
        self.saveToLocal(jsonString: currentExerciseArray.toJSONString(), localKey: .current)
    }
    
    
    func updateScore(wordId: Int, score: Int) {
        
        if var map = YYCache.object(forKey: key(.score)) as? [Int : Int] {
            map[wordId] = score
            YYCache.set(map, forKey: key(.score))
        } else {
            YYCache.set([wordId : score], forKey: key(.score))
        }

    }
    
    
    func fetchScore(wordId: Int) -> Int {
        guard let map = YYCache.object(forKey: key(.score)) as? [Int : Int]  else {
            return 10
        }
        return map[wordId] ?? 10
    }
    
    func initProgressStatus(reviewWordIds: [Int]?) {
        YYCache.set(false, forKey: key(.completion))
        YYCache.set(reviewWordIds, forKey: key(.reviewWordIds))
    }
    

    /// 本地未学完的数据
    func localExerciseModels() -> ([YXWordExerciseModel], [YXWordStepsModel], [YXWordExerciseModel]) {
        var filePath = YYDataSourceManager.dbFilePath(fileName: key(.new))
        var new: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            new = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: key(.review))
        var review: [YXWordStepsModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            review = Array<YXWordStepsModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: key(.current))
        var current: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            current = Array<YXWordExerciseModel>(JSONString: str)
        }
        return (new ?? [], review ?? [], current ?? [])
    }
    
    
    /// 完成答题
    func completionExercise() {
        YYCache.remove(forKey: key(.completion))
        YYCache.set(false, forKey: key(.report))
    }
    
    
    /// 完成上报
    func completionReport() {
        YYCache.remove(forKey: key(.report))        
        YYCache.remove(forKey: key(.skipNewWord))
        
        var filePath = YYDataSourceManager.dbFilePath(fileName: key(.new))
        var result = YYFileManager.share.clearFile(path: filePath)
        print("新学数据完成，本地数据删除：", result )

        filePath = YYDataSourceManager.dbFilePath(fileName: key(.review))
        result = YYFileManager.share.clearFile(path: filePath)
        print("复习数据完成，本地数据删除：", result )
    }
    
    
    
    /// 更新进度
    /// - Parameter exerciseModels: 数据
    private func saveToLocal(jsonString: String?, localKey: LocalKey) {
        let filePath = YYDataSourceManager.dbFilePath(fileName: key(localKey))
        try? jsonString?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    
//    private func saveToLocal2(exerciseModels: [[YXWordExerciseModel]], localKey: LocalKey) {
//
//        var catchModel = YXCacheWordExerciseModel()
//        catchModel.steps = exerciseModels
//
//        let str = catchModel.toJSONString()
//        let filePath = YYDataSourceManager.dbFilePath(fileName: key(localKey))
//        try? str?.write(toFile: filePath, atomically: true, encoding: .utf8)
//    }
    
}
