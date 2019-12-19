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
        case previous = "previous.txt"
        
        case currentTurnIndex = "Exercise_Current_Turn"
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
        
        case newWordIds = "New_Word_Id_List"
        case reviewWordIds = "Review_Word_Id_List"
    
        case score = "Exercise_Score"
        case skipNewWord = "Skip_New_Word"
        case showGuideView = "a"
    }
    
    
    override init() {
        super.init()
    }
    
    init(bookId: Int, unitId: Int) {
        super.init()
        self.bookId = bookId
        self.unitId = unitId        
    }
    
    
    //MARK: - Get
    
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
    
    
    /// 待复习的单词列表
    func reviewWordIds() -> [Int] {
        if let list = YYCache.object(forKey: key(.reviewWordIds)) as? [Int] {
            return list
        }
        return []
    }
    
    
    func currentTurnIndex() -> Int {
        if let turn = YYCache.object(forKey: key(.currentTurnIndex)) as? Int {
            return turn
        }
        return 0
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
    
    
    func fetchScore(wordId: Int) -> Int {
        guard let map = YYCache.object(forKey: key(.score)) as? [Int : Int]  else {
            return 10
        }
        return map[wordId] ?? 10
    }
    
    
    /// 本地未学完的数据
    func loadLocalExerciseModels() -> ([YXWordExerciseModel], [YXWordStepsModel]) {
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
        return (new ?? [], review ?? [])
    }
    
    
    func loadLocalTurnData() -> ([YXWordExerciseModel], [YXWordExerciseModel]) {
        var filePath = YYDataSourceManager.dbFilePath(fileName: key(.current))
        var current: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            current = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        filePath = YYDataSourceManager.dbFilePath(fileName: key(.previous))
        var previous: [YXWordExerciseModel]?
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8) {
            previous = Array<YXWordExerciseModel>(JSONString: str)
        }
        
        return (current ?? [], previous ?? [])
    }
    
    
    func loadLocalWordsProgress() -> ([Int], [Int]) {
        let new = YYCache.object(forKey: key(.newWordIds)) as? [Int] ?? []
        let review = YYCache.object(forKey: key(.reviewWordIds)) as? [Int] ?? []
        return (new, review)
    }
    
    
    
    //MARK: - Set
    
    func setSkipNewWord() {
        YYCache.set(true, forKey: key(.skipNewWord))
    }
    
    func setCurrentTurn(index: Int) {
        YYCache.set(index, forKey: key(.currentTurnIndex))
    }
    
    
    /// 跟新练习进度
    /// - Parameters:
    ///   - newExerciseModel: 新学
    ///   - reviewExerciseModel: 复习
    func updateProgress(newWordArray: [YXWordExerciseModel], reviewWordArray: [YXWordStepsModel]) {
        self.saveToLocalFile(jsonString: newWordArray.toJSONString(), localKey: .new)
        self.saveToLocalFile(jsonString: reviewWordArray.toJSONString(), localKey: .review)
    }
    
    
    func updateTurnProgress(currentTurnArray: [YXWordExerciseModel], previousTurnArray: [YXWordExerciseModel]) {
        self.saveToLocalFile(jsonString: currentTurnArray.toJSONString(), localKey: .current)
        self.saveToLocalFile(jsonString: previousTurnArray.toJSONString(), localKey: .previous)
    }
    
    
    func updateScore(wordId: Int, score: Int) {
        
        if var map = YYCache.object(forKey: key(.score)) as? [Int : Int] {
            map[wordId] = score
            YYCache.set(map, forKey: key(.score))
        } else {
            YYCache.set([wordId : score], forKey: key(.score))
        }

    }

    
    func initProgressStatus(newWordIds: [Int]?, reviewWordIds: [Int]?) {
        YYCache.set(false, forKey: key(.completion))
        
        YYCache.set(newWordIds, forKey: key(.newWordIds))
        YYCache.set(reviewWordIds, forKey: key(.reviewWordIds))
    }
    
    
    /// 完成答题
    func completionExercise() {
        YYCache.remove(forKey: key(.completion))
        YYCache.set(false, forKey: key(.report))
    }
    

    /// 完成上报
    func completionReport() {
        YYCache.remove(forKey: key(.report))
        YYCache.remove(forKey: key(.score))
        YYCache.remove(forKey: key(.currentTurnIndex))
        YYCache.remove(forKey: key(.newWordIds))
        YYCache.remove(forKey: key(.reviewWordIds))
        YYCache.remove(forKey: key(.skipNewWord))
        
        removeLocalFile(.new)
        removeLocalFile(.review)
        removeLocalFile(.current)
        removeLocalFile(.previous)
    }
    
    
    
    //MARK: - Private
    private func key(_ key: LocalKey) -> String {
        return "\(bookId)_\(unitId)_\(YXConfigure.shared().uuid ?? "")_" + key.rawValue
    }
    
    /// 保持到本地文件
    /// - Parameter exerciseModels: 数据
    private func saveToLocalFile(jsonString: String?, localKey: LocalKey) {
        let filePath = YYDataSourceManager.dbFilePath(fileName: key(localKey))
        try? jsonString?.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    private func removeLocalFile(_ localKey: LocalKey) {
        let filePath = YYDataSourceManager.dbFilePath(fileName: self.key(localKey))
        let result = YYFileManager.share.clearFile(path: filePath)
        print(localKey, "数据完成，本地数据删除：", result )
    }
    
}
