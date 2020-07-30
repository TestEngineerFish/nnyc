//
//  YXWordBookResourceManager.swift
//  YXEDU
//
//  Created by Jake To on 11/7/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

class YXWordBookResourceManager: NSObject, URLSessionTaskDelegate {
    typealias FinishedBlock = (()->Void)

    var group                     = DispatchGroup()
    static var totalDownloadCount = 0
    static let shared             = YXWordBookResourceManager()
    static var stop               = false {
        willSet {
            if newValue {
                YXLog("开始学习/退出登录停止下载")
                YXWordBookResourceManager.downloadDataList.removeAll()
            }
        }
    }
    /// 下载队列
    static var downloadDataList  = [(Int, String)]()
    /// 失败的任务
    static var errorDownloadDict = [String:Int]()
    /// 下载对象列表，存储所以需要下载的任务式对象
    static var taskList = [YXWordBookResourceModel]()

    private override init() {
        super.init()
    }

    /// 检测词书是否需要下载（可指定词书ID，未指定则检测当前用户所有词书）
    func contrastBookData(by bookId: Int? = nil) {
        let request = YXWordBookRequest.downloadWordBook(bookId: bookId)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordBookDownloadModel>.self, request: request, success: {  [weak self] (response) in
            guard let self = self else { return }
            if let wordBookDownloadModels = response.dataArray {
                if let bookId = bookId {
                    // 下载单本书
                    if wordBookDownloadModels.isEmpty {
                        self.downloadFinished()
                    } else {
                        wordBookDownloadModels.forEach { (wordBookDownloadModel) in
                            if wordBookDownloadModel.id == bookId {
                                self.checkLocalBooksStatus(with: [wordBookDownloadModel])
                                return
                            }
                        }
                    }
                } else {
                    self.checkLocalBooksStatus(with: wordBookDownloadModels)
                }
            } else {
                YXLog("后台返回词书列表数据错误")
                self.downloadFinished()
                self.popRootVC()
            }
        }) { error in
            YXLog("检测词书接口请求失败:\(error.message)")
            self.downloadFinished()
            YXUtils.showHUD(nil, title: error.message)
            self.popRootVC()
        }
    }

    /// 检测词书是否需要下载/更新
    private func checkLocalBooksStatus(with wordBookDownloadModelList: [YXWordBookDownloadModel]) {
        var dataList = [(Int, String)]()
        for wordBookDownloadModel in wordBookDownloadModelList {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash else { continue }
            dataList.append((bookId, bookHash))
        }
        YXWordBookResourceManager.downloadDataList += self.getUpdateList(dataList: dataList)

        // 如果有需要下载的词书
        if YXWordBookResourceManager.downloadDataList.count > 0 {
            self.downloadProcessor()
        } else {
            YXLog("没有需要更新的词书")
            self.downloadFinished()
        }
    }

    // TODO: ==== 词单
    /// 保存词单
      /// - Parameters:
      ///   - dataList: 需要保存的数据
    func saveReviewPlan(dataList: [(Int, String)], type: YXDownloadType = .reviewPlan, word id: Int = 0) {
        YXLog("词单的词书列表", dataList)
        let task = YXWordBookResourceModel(type: type, workId: id) {
            YXLog("词书下载完成，开始检测和下载词单的词书")
            YXWordBookResourceManager.downloadDataList += self.getUpdateList(dataList: dataList)
            self.downloadProcessor()
        }
        self.addTask(model: task)
      }

    /// 下载任务处理者
    private func downloadProcessor() {
        DispatchQueue.global().async(group: group, qos: .default, flags: []) {
            // 退出登录停止下载
            if !YXUserModel.default.didLogin {
                YXWordBookResourceManager.downloadDataList.removeAll()
                return
            }
            for (index, model) in YXWordBookResourceManager.downloadDataList.enumerated() {
                if index < 10 {
                    YXWordBookResourceManager.shared.group.enter()
                    self.downloadSingleWordBook(with: model.0, newHash: model.1)
                }
            }
        }
        group.notify(queue: .global()) {
            if YXWordBookResourceManager.downloadDataList.isEmpty {
                self.downloadFinished()
            } else {
                if YXWordBookResourceManager.stop {
                    YXLog("学习中，不再继续下载词书")
                    self.downloadFinished()
                } else {
                    YXLog("继续下载词书")
                    self.downloadProcessor()
                }
            }
        }
    }

    /// 添加任务
    func addTask(model: YXWordBookResourceModel) {
        var existed = false
        // 任务是否已存在
        YXWordBookResourceManager.taskList.forEach { (_model) in
            if _model.type == model.type {
                // 如果是作业类型，则需要匹配作业ID
                if _model.type == .homework {
                    if  _model.workId == model.workId {
                        existed = true
                        return
                    }
                } else {
                    existed = true
                    return
                }
            }
        }
        if !existed {
            YXWordBookResourceManager.taskList.append(model)
        }
        // 如果首个任务未开始下载，则开始任务
        if YXWordBookResourceManager.taskList.first?.status != .some(.downloading) {
            self.processorTask()
        }
    }

    /// 处理任务
    func processorTask() {
        guard let taskModel = YXWordBookResourceManager.taskList.first else {
            YXLog("✅所有下载词书队列任务处理完成✅")
            YXWordBookResourceManager.errorDownloadDict.removeAll()
            return
        }
        taskModel.status = .downloading
        taskModel.eventBlock()
    }

    /// 单次任务完成事件
    private func downloadFinished() {
        YXLog("==== 当前任务处理完成✅ ====")
        //用于发送完成通知
        YXWordBookResourceManager.taskList.first?.status = .finished
        YXWordBookResourceManager.taskList.removeFirst()
        // 处理之后的任务
        self.processorTask()
    }

    /// 下载单本词书
    private func downloadSingleWordBook(with bookId: Int, newHash: String) {
        YXLog("下载词书， BookID：\(bookId)", "newHash:", newHash)
        let request = YXWordBookRequest.getBookWord(bookId: bookId)
        YYNetworkService.default.request(YYStructResponse<YXWordBookModel>.self, request: request, success: { [weakself = self] (response) in
            guard var bookModel = response.data else {
                weakself.downloadError(with: bookId, newHash: newHash, error: "下载词书数据解析错误")
                return
            }
            YXLog("下载\(bookId)完成...")
            bookModel.bookHash = newHash
            DispatchQueue.global().async {
                weakself.updateWords(with: bookModel)
            }
        }) { (error) in
            self.downloadError(with: bookId, newHash: newHash, error: error.message)
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    /// 词书下载处理
    /// - Parameters:
    ///   - bookId: 词书ID
    ///   - newHash: 新词书的哈希值
    ///   - msg: 错误原因
    func downloadError(with bookId: Int?, newHash: String?, error msg: String?) {

        YXWordBookResourceManager.shared.group.leave()
        if let _msg = msg {
            YXLog(_msg)
            let _bookId  = bookId ?? 0
            let _newHash = newHash ?? ""
            let downloadCount: Int = YXWordBookResourceManager.errorDownloadDict[_newHash] ?? 0
            if downloadCount < 1 {
                YXWordBookResourceManager.downloadDataList.append((_bookId, _newHash))
                YXWordBookResourceManager.errorDownloadDict[_newHash] = downloadCount + 1
            } else {
                NotificationCenter.default.post(name: YXNotification.kDownloadWordError, object: nil)
                YXWordBookResourceManager.downloadDataList.removeAll()
                YXWordBookResourceManager.errorDownloadDict.removeAll()
            }
        }
    }

    // TODO: ---- Tools ----

    /// 获得需要更新/下载的列表
    /// - Parameter dataList: 需要检测的数据
    /// - Returns: 返回需要更新/下载的数据
    func getUpdateList(dataList: [(Int, String)]) -> [(Int, String)] {
        var resultList = [(Int, String)]()
        dataList.forEach { (data) in
            let wordBook = YXWordBookDaoImpl().selectBook(bookId: data.0)
            // 本地不存在，或者本地Hash值与后台不一致，则更新
            if (wordBook == nil || wordBook?.bookHash != .some(data.1)) {
                YXLog("开始下载词书")
                if wordBook == nil {
                    YXLog("本地没有这个本书")
                } else {
                    YXLog("新Hash，需要更新")
                    YXLog("本地Hash", wordBook?.bookHash ?? "")
                    YXLog("新的Hash", data.1)
                }
                resultList.append(data)
            }
        }
        YXWordBookResourceManager.totalDownloadCount = resultList.count
        return resultList
    }

    private func popRootVC() {
        YRRouter.sharedInstance().currentNavigationController()?.popToRootViewController(animated: true)
    }

    // TODO: ---- 本地词书数据库操作 ----

    /// 保存、更新单词
    private func updateWords(with bookModel: YXWordBookModel) {
        if YXWordBookResourceManager.stop {
            YXWordBookResourceManager.shared.downloadError(with: bookModel.bookId, newHash: bookModel.bookHash, error: "当前正在学习中，不再下载其他词书")
            return
        }
        YXWordBookDaoImpl().updateWords(bookModel: bookModel)
    }
}

enum YXDownloadType: Int {
    case single
    case all
    case reviewPlan
    case homework
}

///  下载对象
class YXWordBookResourceModel: NSObject {
    enum YXDownloadStatus: Int {
        case normal
        case downloading
        case finished
    }
    var bookId: Int?
    var type: YXDownloadType
    var workId: Int = 0 // 作业ID
    var status: YXDownloadStatus {
        didSet {
            if status == .finished {
                YXLog("下载完成，发送通知")
                switch self.type {
                case .single:
                    YXLog("单本词书下载完成")
                    NotificationCenter.default.post(name: YXNotification.kDownloadSingleFinished, object: nil)
                case .all:
                    YXLog("所有词书下载完成")
                    NotificationCenter.default.post(name: YXNotification.kDownloadAllFinished, object: nil)
                case .reviewPlan:
                    YXLog("所有词单下载完成")
                    NotificationCenter.default.post(name: YXNotification.kDownloadReviewPlanFinished, object: nil)
                case .homework:
                    YXLog("作业下载完成")
                    NotificationCenter.default.post(name: YXNotification.kDownloadReviewPlanFinished, object: nil)
                }

            }
        }
    }
    var eventBlock: (()->Void)

    init(type: YXDownloadType, book id: Int? = -1, workId: Int = 0, block: @escaping (()->Void)) {
        self.type       = type
        self.bookId     = id
        self.workId     = workId
        self.status     = .normal
        self.eventBlock = block
        super.init()
    }

}

