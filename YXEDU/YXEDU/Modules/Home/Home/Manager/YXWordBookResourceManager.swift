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

    var group                              = DispatchGroup()
    static var totalDownloadCount          = 0
    static let shared                      = YXWordBookResourceManager()
    static var currentBookDownloadFinished = false
    static var isLearning                  = false {
        willSet {
            if newValue {
                YXLog("开始学习")
                YXWordBookResourceManager.downloadDataList.removeAll()
            } else {
                YXLog("学习结束")
            }
        }
    }
    var targetBookId: Int? // 如果有目标词书ID，则只检测一本词书，否则全部检测下载
    static var downloadDataList = [(Int, String)]()
    static var downloading: Bool?
    static var hasDownloadTask: Bool = false

    // ---- 仅保存词单用----
    /// 词单下载完成闭包
    static var reviewPlanEventBlock: FinishedBlock?
    /// 下载词单结束闭包
    static var reviewPlanFinishBlock: FinishedBlock?

    private override init() {
        super.init()
    }

    func reset() {
        YXWordBookResourceManager.totalDownloadCount    = .zero
        YXWordBookResourceManager.downloading           = false
        YXWordBookResourceManager.reviewPlanFinishBlock = nil
        YXWordBookResourceManager.reviewPlanEventBlock  = nil
        YXWordBookResourceManager.downloadDataList      = []
        if YXWordBookResourceManager.shared.targetBookId == nil {
            YXWordBookResourceManager.hasDownloadTask = false
        }
    }

    /// 检测词书是否需要下载（可指定词书ID，未指定则检测当前用户所有词书）
    func contrastBookData(by bookId: Int? = nil) {
        // 下载中，则不做检测处理，防止重复下载
        if (YXWordBookResourceManager.downloading == .some(true) || YXUserModel.default.currentBookId == .some(0)) && !YXWordBookResourceManager.hasDownloadTask {
            YXLog("词书下载中，请勿重复下载")
            // 新用户会先进入首页再进入词书选择页
            if YXUserModel.default.currentBookId == .some(0) {
                YXLog("当前用户没有正在学习的词书")
                return
            }
            if bookId == nil {
                // -- 检测所有词书
                // 如果还在下载当前词书，则在下载完当前词书后，开始检测其他词书
                if YXWordBookResourceManager.currentBookDownloadFinished == false {
                    YXWordBookResourceManager.hasDownloadTask = true
                    YXLog("还在下载当前词书，则在下载完当前词书后，开始检测其他词书")
                    YXWordBookResourceManager.reviewPlanEventBlock = {
                        YXLog("当前词书已完成，开始下载所有词书")
                        self.contrastBookData()
                    }
                }
            } else {
                // -- 下载当前词书
                // 暂停所有下载，优先下载当前词书
                YXLog("停止所有未下载的词书")
                YXWordBookResourceManager.downloadDataList.removeAll()
            }
            return
        }
        YXWordBookResourceManager.downloading = true
        let request = YXWordBookRequest.downloadWordBook(bookId: bookId)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordBookDownloadModel>.self, request: request, success: {  [weak self] (response) in
            self?.targetBookId = bookId
            guard let self = self else {
                YXWordBookResourceManager.downloading = false
                return
            }
            if let wordBookDownloadModels = response.dataArray {
                if let bookId = bookId {
                    // 下载单本书
                    wordBookDownloadModels.forEach { (wordBookDownloadModel) in
                        if wordBookDownloadModel.id == bookId {
                            self.checkLocalBooksStatus(with: [wordBookDownloadModel])
                            return
                        }
                    }
                } else {
                    self.checkLocalBooksStatus(with: wordBookDownloadModels)
                }
            } else {
                YXLog("后台返回词书列表数据错误")
                YXWordBookResourceManager.downloading = false
                self.popRootVC()
            }
        }) { error in
            YXLog("检测词书接口请求失败:\(error.message)")
            YXUtils.showHUD(kWindow, title: error.message)
            YXWordBookResourceManager.downloading = false
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
            YXWordBookResourceManager.downloading = true
            self.downloadProcessor()
        } else {
            YXLog("没有需要更新的词书")
            YXWordBookResourceManager.currentBookDownloadFinished = true
            YXWordBookResourceManager.downloading                 = false
            self.downloadFinished()
        }
    }

    // TODO: ==== 词单
    /// 保存词单
      /// - Parameters:
      ///   - dataList: 需要保存的数据
      ///   - block: 保存后执行的闭包
      func saveReviewPlan(dataList: [(Int, String)], finished block: FinishedBlock?) {
          YXLog("词单的词书列表", dataList)
          YXWordBookResourceManager.reviewPlanFinishBlock = block
          if YXWordBookResourceManager.downloading == .some(true) {
              YXLog("正在下载词书")
              YXWordBookResourceManager.reviewPlanEventBlock = {
                  YXLog("词书下载完成，开始检测和下载词单的词书")
                  YXWordBookResourceManager.downloadDataList += self.getUpdateList(dataList: dataList)
                  self.downloadProcessor()
              }
          } else {
              YXLog("没有下载词书，直接下载词单的词书")
              YXWordBookResourceManager.downloadDataList += self.getUpdateList(dataList: dataList)
              self.downloadProcessor()
          }
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
                if YXWordBookResourceManager.isLearning {
                    YXLog("学习中，不再继续下载词书")
                    self.downloadFinished()
                } else {
                    YXLog("继续下载词书")
                    self.downloadProcessor()
                }
            }
        }
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
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 下载、检测完成事件
    private func downloadFinished() {
        YXLog("==== 写入DB数据完成✅ ====")
        if self.targetBookId != nil {
            YXWordBookResourceManager.currentBookDownloadFinished = true
        }
        YXWordBookResourceManager.reviewPlanEventBlock?()
        YXWordBookResourceManager.reviewPlanEventBlock = nil
        YXWordBookResourceManager.reviewPlanFinishBlock?()
        YXWordBookResourceManager.reviewPlanFinishBlock = nil
        self.reset()
    }

    /// 词书下载处理
    /// - Parameters:
    ///   - bookId: 词书ID
    ///   - newHash: 新词书的哈希值
    ///   - msg: 错误原因
    func downloadError(with bookId: Int?, newHash: String?, error msg: String?) {
        let _bookId  = bookId ?? 0
        let _newHash = newHash ?? ""
        if let _msg = msg {
            YXLog(_msg)
            YXWordBookResourceManager.downloadDataList.append((_bookId, _newHash))
        }
        YXWordBookResourceManager.shared.group.leave()
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
                if YXUserModel.default.currentBookId == wordBook?.bookId {
                    YXLog("当前学习的词书需要更新")
                    YXWordBookResourceManager.currentBookDownloadFinished = false
                }
                resultList.append(data)
            } else if YXUserModel.default.currentBookId == wordBook?.bookId {
                YXLog("》〉》已存在当前词书")
                YXWordBookResourceManager.currentBookDownloadFinished = true
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
        if YXWordBookResourceManager.isLearning {
            YXWordBookResourceManager.shared.downloadError(with: bookModel.bookId, newHash: bookModel.bookHash, error: "当前正在学习中，不再下载其他词书")
            return
        }
        YXWordBookDaoImpl().updateWords(bookModel: bookModel)
    }
}

