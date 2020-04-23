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
    static let shared = YXWordBookResourceManager()
    private override init() {
        super.init()
    }
    
    static var isDownloading   = false
    static var wordNumber      = 0
    var downloadBookCount      = 0
    static var writeDBFinished: Bool?
    private var closure: ((_ isSuccess: Bool) -> Void)?
    var finishBlock: (()->Void)?

    /// 检测词书是否需要下载（可指定词书ID，未指定则检测当前用户所有词书）
    func contrastBookData(by bookId: Int? = nil, _ closure: ((_ isSuccess: Bool) -> Void)? = nil) {
        // 下载中，并且不指定词书ID，则不做检测处理，防止重复下载
        if YXWordBookResourceManager.isDownloading, bookId == nil {
            return
        }
        self.closure = closure
        let request = YXWordBookRequest.downloadWordBook(bookId: bookId)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordBookDownloadModel>.self, request: request, success: {  [weak self] (response) in
            guard let self = self else { return }
            if let wordBookDownloadModels = response.dataArray {
                if let bookId = bookId {
                    self.downloadBookCount = 0
                    for wordBookDownloadModel in wordBookDownloadModels {
                        if wordBookDownloadModel.id == bookId {
                            self.checkLocalBooksStatus(with: [wordBookDownloadModel])
                        }
                    }
                } else {
                    self.downloadBookCount = 0
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
    
    /// 检测本地词书Hash值
    /// 仅针对保存别人分享的词单
    func checkLocalBookHash(with bookId: Int, newHash: String) {
        let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId)
        // 本地不存在，或者本地Hash值与后台不一致，则更新
        if (wordBook == nil || wordBook?.bookHash != .some(newHash)) {
            self.downloadSingleWordBook(with: bookId, newHash: newHash)
        } else {
            self.downloadBookCount    -= 1
            if self.downloadBookCount == 0 && self.finishBlock != nil {
                self.finishBlock?()
            }
        }
    }

    /// 检测本地词书是否需要更新
    private func checkLocalBooksStatus(with wordBookDownloadModelList: [YXWordBookDownloadModel]) {
        for wordBookDownloadModel in wordBookDownloadModelList {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash else { continue }
            let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId)
            // 本地不存在，或者本地Hash值与后台不一致，则更新
            if (wordBook == nil || wordBook?.bookHash != .some(bookHash)) {
                YXLog("开始下载词书")
                if wordBook == nil {
                    YXLog("本地没有这个本书")
                } else {
                    YXLog("本地Hash", wordBook?.bookHash ?? "")
                    YXLog("新Hash", bookHash)
                    YXLog("新的Hash。需要更新")
                }
                self.downloadBookCount += 1
                self.downloadSingleWordBook(with: bookId, newHash: bookHash)
            }
        }
        // 如果有需要下载的词书
        if self.downloadBookCount > 0 {
            YXWordBookResourceManager.writeDBFinished = false
            self.closure?(false)
        } else {
            YXLog("没有需要更新的词书")
            YXWordBookResourceManager.writeDBFinished = true
            self.closure?(true)
        }
    }

    /// 下载单本词书
    private func downloadSingleWordBook(with bookId: Int, newHash: String) {
        YXWordBookResourceManager.isDownloading = true
        YXLog("下载词书， BookID：\(bookId)", "newHash:", newHash)
        let request = YXWordBookRequest.getBookWord(bookId: bookId)
        YYNetworkService.default.request(YYStructResponse<YXWordBookModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, var bookModel = response.data else {
                return
            }
            bookModel.bookHash = newHash
            DispatchQueue.global().async {
                self.saveWords(with: bookModel, async: true)
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    // TODO: ---- 本地词书数据库操作 ----

    /// 保存、更新词书
    private func saveBook(with bookModel: YXWordBookModel, async: Bool) {
        YXWordBookDaoImpl().insertBook(book: bookModel, async: async)
        YXLog("保存词书\(bookModel.bookName ?? "")完成")
    }

    /// 保存、更新单词
    private func saveWords(with bookModel: YXWordBookModel, async: Bool) {
        guard let unitsList = bookModel.units else {
            return
        }
        var lastUnit = false
        /// 赋值自定义数据
        for (unitIndex, unitModel) in unitsList.enumerated() {
            guard let wordsList = unitModel.words else {
                continue
            }
            if unitIndex == unitsList.count - 1 {
                lastUnit = true
            }
            for (index,var wordModel) in wordsList.enumerated() {
                wordModel.gradeId         = bookModel.gradeId
                wordModel.gardeType       = bookModel.gradeType ?? 1
                wordModel.bookId          = bookModel.bookId
                wordModel.unitId          = unitModel.unitId
                wordModel.unitName        = unitModel.unitName
                wordModel.isExtensionUnit = unitModel.isExtensionUnit
                YXWordBookDaoImpl().insertWord(word: wordModel, async: async)
//                YXWordBookResourceManager.wordNumber += 1
//                YXLog("当前已写入单词书名：\(bookModel.bookName ?? "")")
//                YXLog("当前已写入单词数\(YXWordBookResourceManager.wordNumber)")
                if index == wordsList.count - 1 && lastUnit {
                    YXLog("==== 词书\(bookModel.bookId ?? 0)写入完成 ====")
                    self.downloadBookCount -= 1
                    YXLog("当前剩余下载词书数量\(self.downloadBookCount)")
                    self.saveBook(with: bookModel, async: true)
                    if self.downloadBookCount == 0 {
                        YXLog("==== 写入DB数据完成✅ ====")
                        YXWordBookResourceManager.writeDBFinished = true
                    }
                    if self.downloadBookCount == 0 {
                        YXWordBookResourceManager.isDownloading = false
                        self.finishBlock?()
                    }
                }
            }
        }
    }
}

