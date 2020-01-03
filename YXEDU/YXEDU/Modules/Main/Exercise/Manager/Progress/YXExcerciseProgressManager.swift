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
    
//    static var`default` = YXExcerciseProgressManager()
    
    public var bookId: Int? { didSet { updateBookId() } }
    public var unitId: Int? { didSet { updateUnitId() } }
    public var dataType: YXExerciseDataType = .base
    public var planId: Int?
    
    /// 本地存储Key
    enum LocalKey: String {
        case daliyKeys = "Exercise_Daliy_Key_List"
        
        case new = "new.txt"
        case review = "review.txt"
        case current = "current.txt"
        case previous = "previous.txt"
        
        case bookId = "Book_Id"
        case unitId = "Unit_Id"
        
        case currentTurnIndex = "Exercise_Current_Turn"
        case report = "Exercise_Report_Status"
        case completion = "Exercise_Completion_Status"
        
        case newWordIds = "New_Word_Id_List"
        case reviewWordIds = "Review_Word_Id_List"
    
        case score = "Exercise_Score"
        case errorCount = "Error_Count"
        case newWordReadScore = "New_Word_Read_Score"   // 新学跟读得分
        case skipNewWord = "Skip_New_Word"
    }
    

    override init() {
        super.init()
    }
    
    
    //MARK: - Get
    
    /// 关卡是否上报
    func isReport() -> Bool {
        // 清除之前的数据
//        clearBeforeData()
        
        if let _ = YYCache.object(forKey: key(.report)) as? Bool {
            return false
        }
        return true
    }
    
    /// 关卡是否学完
    func isCompletion() -> Bool {
        // 清除之前的数据
//        clearBeforeData()
        
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
    
    
    func fetchErrorCount(wordId: Int) -> Int {
        guard let map = YYCache.object(forKey: key(.errorCount)) as? [Int : Int]  else {
            return 0
        }
        return map[wordId] ?? 0
    }
    
    
    func fetchScore(wordId: Int) -> Int {
        guard let map = YYCache.object(forKey: key(.score)) as? [Int : Int]  else {
            return 10
        }
        return map[wordId] ?? 10
    }
    
    func fetchNewWordReadScore(wordId: Int) -> Int {
        guard let map = YYCache.object(forKey: key(.newWordReadScore)) as? [Int : Int]  else {
            return 0
        }
        return map[wordId] ?? 0
    }
    
    
    func fetchBookIdAndUnitId() -> (Int?, Int?) {
        var bookId: Int?, unitId: Int?
        if let b = YYCache.object(forKey: key(.bookId)) as? Int {
            bookId = b
        }
        if let u = YYCache.object(forKey: key(.unitId)) as? Int {
            unitId = u
        }
        return (bookId, unitId)
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
    
    
    func updateErrorCount(wordId: Int) {
        if var map = YYCache.object(forKey: key(.errorCount)) as? [Int : Int] {
            map[wordId] = (map[wordId] ?? 0) + 1
            YYCache.set(map, forKey: key(.errorCount))
        } else {
            YYCache.set([wordId : 1], forKey: key(.errorCount))
        }
    }

    func updateNewWordReadScore(wordId: Int, score: Int) {
        if var map = YYCache.object(forKey: key(.newWordReadScore)) as? [Int : Int] {
            map[wordId] = score
            YYCache.set(map, forKey: key(.newWordReadScore))
        } else {
            YYCache.set([wordId : score], forKey: key(.newWordReadScore))
        }
    }
    
    
    func initProgressStatus(newWordIds: [Int]?, reviewWordIds: [Int]?) {
        YYCache.set(false, forKey: key(.completion))
        
        YYCache.set(newWordIds, forKey: key(.newWordIds))
        YYCache.set(reviewWordIds, forKey: key(.reviewWordIds))
    }
    
    
    private func updateBookId() {
        YYCache.set(bookId, forKey: key(.bookId))
    }

    private func updateUnitId() {
        YYCache.set(unitId, forKey: key(.unitId))
    }
    
    private func addDaliyKey(daliy: String) {
        if var list = YYCache.object(forKey: LocalKey.daliyKeys.rawValue) as? [String] {
            if !list.contains(daliy) {
                list.append(daliy)
                YYCache.set(list, forKey: LocalKey.daliyKeys.rawValue)
            }
        } else {
            YYCache.set([daliy], forKey: LocalKey.daliyKeys.rawValue)
        }
    }
    
//    func initBookIdAndUnitId(bookId: Int?, unitId: Int?) {
//        self.bookId = bookId
//        self.unitId = unitId
//
//        YYCache.set(bookId, forKey: key(.bookId))
//        YYCache.set(unitId, forKey: key(.unitId))
//    }
    
    
    /// 完成答题
    func completionExercise() {
        YYCache.remove(forKey: key(.completion))
        YYCache.set(false, forKey: key(.report))
    }
    

    /// 完成上报
    func completionReport(daliy: String? = nil) {
        YYCache.remove(forKey: key(.bookId))
        YYCache.remove(forKey: key(.unitId))
        YYCache.remove(forKey: key(.report))
        YYCache.remove(forKey: key(.score))
        YYCache.remove(forKey: key(.errorCount))
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
        
        let today = self.today()
        let bid = bookId == nil ? "b_" :  "\(bookId!)_"
        let uid = unitId == nil ? "c_" :  "\(unitId!)_"
        let uuid = YXConfigure.shared().uuid ?? ""
        let pid = planId == nil ? "a_" :  "\(planId!)_"
                
//        self.addDaliyKey(daliy: today)
        
        if dataType == .base {
            return today + "_\(uuid)_\(dataType.rawValue)_\(bid)_\(uid)_pNull" + key.rawValue
        }
        return today + "_\(uuid)_\(dataType.rawValue)_bNull_uNull_\(pid)" + key.rawValue
    }
    
    private func today() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.string(from: Date())
    }
    
    
    private func clearBeforeData() {
        guard let list = YYCache.object(forKey: LocalKey.daliyKeys.rawValue) as? [String]  else {
            return
        }
        
        let today = self.today()
        for daliy in list {
            if daliy != today {
                completionReport(daliy: daliy)
            }
        }
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
