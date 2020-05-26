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
    var group                              = DispatchGroup()
    var totalDownloadCount                 = 0
    static let shared                      = YXWordBookResourceManager()
    static var currentBookDownloadFinished = true
    static var groupCount = 0
    static var isLearning                  = false {
        willSet {
            YXWordBookResourceManager.writeDBFinished = true
            if newValue {
                YXLog("开始学习")
                YXWordBookResourceManager.shared.finishBlock?()
                YXWordBookResourceManager.shared.backupBlock?()
                YXWordBookResourceManager.downloadDataList.removeAll()
            } else {
                YXLog("学习结束")
//                还在下载，返回重新设置group。crash
//                YXWordBookResourceManager.shared.group    = DispatchGroup()
                YXWordBookResourceManager.shared.contrastBookData()
            }
        }
    }

    var backupBlock: (()->Void)?
    static var downloadDataList = [(Int, String)]()
    static var writeDBFinished: Bool?
    private var closure: ((_ isSuccess: Bool) -> Void)?
    var finishBlock: (()->Void)?

    private override init() {
        super.init()
    }

    /// 检测词书是否需要下载（可指定词书ID，未指定则检测当前用户所有词书）
    func contrastBookData(by bookId: Int? = nil, _ closure: ((_ isSuccess: Bool) -> Void)? = nil) {
        // 下载中，并且不指定词书ID，则不做检测处理，防止重复下载
        if YXWordBookResourceManager.writeDBFinished == .some(false) && bookId == nil {
            return
        }
        self.closure = closure
        let request = YXWordBookRequest.downloadWordBook(bookId: bookId)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordBookDownloadModel>.self, request: request, success: {  [weak self] (response) in
            guard let self = self else { return }
            if let wordBookDownloadModels = response.dataArray {
                if let bookId = bookId {
                    for wordBookDownloadModel in wordBookDownloadModels {
                        if wordBookDownloadModel.id == bookId {
                            self.checkLocalBooksStatus(with: [wordBookDownloadModel])
                        }
                    }
                } else {
                    self.checkLocalBooksStatus(with: wordBookDownloadModels)
                }
            } else {
                closure?(false)
            }
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
            closure?(false)
        }
    }


    /// 保存词单
    /// - Parameters:
    ///   - dataList: 需要保存的数据
    ///   - block: 保存后执行的闭包
    func saveReviewPlan(dataList: [(Int, String)], finished block: (()->Void)?) {
        if YXWordBookResourceManager.writeDBFinished == .some(false) {
            YXLog("正在下载词书")
            self.backupBlock = {
                YXLog("词书下载完成，开始检测和下载词单的词书")
                YXLog("词单的词书列表", dataList)
                self.finishBlock = block
                YXWordBookResourceManager.downloadDataList += self.checkLocalBookHash(dataList: dataList)
                self.totalDownloadCount = YXWordBookResourceManager.downloadDataList.count
                self.downloadProcessor()
            }
        } else {
            YXLog("没有下载词书，直接下载词单的词书")
            YXLog("词单的词书列表", dataList)
            self.finishBlock = block
            YXWordBookResourceManager.downloadDataList += self.checkLocalBookHash(dataList: dataList)
            self.totalDownloadCount = YXWordBookResourceManager.downloadDataList.count
            self.downloadProcessor()
        }
    }

    /// 检测本地词书是否需要更新
    private func checkLocalBooksStatus(with wordBookDownloadModelList: [YXWordBookDownloadModel]) {
        var dataList = [(Int, String)]()
        for wordBookDownloadModel in wordBookDownloadModelList {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash else { continue }
            dataList.append((bookId, bookHash))
        }
        YXWordBookResourceManager.downloadDataList += self.checkLocalBookHash(dataList: dataList)

        // 如果有需要下载的词书
        if YXWordBookResourceManager.downloadDataList.count > 0 {
            self.totalDownloadCount = YXWordBookResourceManager.downloadDataList.count
            YXWordBookResourceManager.writeDBFinished = false
            self.closure?(false)
            self.downloadProcessor()
        } else {
            YXLog("没有需要更新的词书")
            YXWordBookResourceManager.currentBookDownloadFinished = true
            YXWordBookResourceManager.writeDBFinished             = true
            self.closure?(true)
        }
    }

    /// 检测是否需要下载
    /// - Parameter dataList: 需要检测的数据
    /// - Returns: 返回需要下载的数据
    func checkLocalBookHash(dataList: [(Int, String)]) -> [(Int, String)] {
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
                if YXUserModel.default.currentBookId == wordBook?.bookId {
                    YXWordBookResourceManager.currentBookDownloadFinished = false
                }
                resultList.append(data)
            }
        }
        return resultList
    }

    /// 下载任务处理者
    private func downloadProcessor() {
        // 优先下载当前正在学习的词书
        self.sortDownloadDataList()
        DispatchQueue.global().async(group: group, qos: .default, flags: []) {
            for (index, model) in YXWordBookResourceManager.downloadDataList.enumerated() {
                if !YXUserModel.default.didLogin {
                    YXWordBookResourceManager.downloadDataList.removeAll()
                    return
                }
                if index < 10 {
                    YXWordBookResourceManager.shared.group.enter()
                    YXWordBookResourceManager.groupCount += 1
                    YXLog("当前线程进入数量：\(YXWordBookResourceManager.groupCount)")
                    self.downloadSingleWordBook(with: model.0, newHash: model.1)
                }
            }
        }
        group.notify(queue: .global()) {
            if YXWordBookResourceManager.downloadDataList.isEmpty {
                YXLog("==== 写入DB数据完成✅ ====")
                YXWordBookResourceManager.writeDBFinished             = true
                self.finishBlock?()
                self.backupBlock?()
            } else {
                YXLog("继续下载词书")
                self.downloadProcessor()
            }
        }
    }

    /// 下载单本词书
    private func downloadSingleWordBook(with bookId: Int, newHash: String) {
        YXLog("下载词书， BookID：\(bookId)", "newHash:", newHash)
        let request = YXWordBookRequest.getBookWord(bookId: bookId)
        YYNetworkService.default.request(YYStructResponse<YXWordBookModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, var bookModel = response.data else {
                YXWordBookResourceManager.shared.group.leave()
                return
            }
            YXLog("下载\(bookId)完成...")
            bookModel.bookHash = newHash
            DispatchQueue.global().async {
                self.updateWords(with: bookModel)
            }
        }) { (error) in
            YXWordBookResourceManager.shared.group.leave()
            YXWordBookResourceManager.groupCount -= 1
            YXLog("当前线程剩余数量：\(YXWordBookResourceManager.groupCount)")
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // TODO: ---- Tools ----
    private func sortDownloadDataList() {
        var tmpList = YXWordBookResourceManager.downloadDataList
        let currentLearningBookId = YXUserModel.default.currentBookId ?? 0
        YXLog("当前正在学习的词书ID：\(currentLearningBookId)")
        for (index, data) in YXWordBookResourceManager.downloadDataList.enumerated() {
            if data.0 == currentLearningBookId {
                tmpList.remove(at: index)
                tmpList.insert(data, at: 0)
            }
        }
        YXWordBookResourceManager.downloadDataList = tmpList
    }

    // TODO: ---- 本地词书数据库操作 ----

    /// 保存、更新单词
    private func updateWords(with bookModel: YXWordBookModel) {
        if YXWordBookResourceManager.isLearning {
            YXLog("当前正在学习中，不再下载其他词书")
            YXWordBookResourceManager.shared.group.leave()
            return
        }
        YXWordBookDaoImpl().updateWords(bookModel: bookModel)
    }
}

