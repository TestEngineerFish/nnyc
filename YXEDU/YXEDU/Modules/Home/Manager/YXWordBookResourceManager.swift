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
    
    var isDownloading     = false
    var downloadBookCount = 0
    private var closure: ((_ isSuccess: Bool) -> Void)?
    var finishBlock: (()->Void)?

    /// 检测词书是否需要下载（可指定词书ID，未指定则检测当前用户所有词书）
    func contrastBookData(by bookId: Int? = nil, _ closure: ((_ isSuccess: Bool) -> Void)? = nil) {
        // 下载中，并且不指定词书ID，则不做检测处理，防止重复下载
        if isDownloading, bookId == nil {
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
    
    /// 检测本地词书Hash值
    func checkLocalBookHash(with bookId: Int, newHash: String) {
        let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId)
        // 本地不存在，或者本地Hash值与后台不一致，则更新
        if (wordBook == nil || wordBook?.bookHash != .some(newHash)) {
            self.downloadSingleWordBook(with: bookId, newHash: newHash)
        } else {
            self.downloadBookCount -= 1
            if self.downloadBookCount == 0 && self.finishBlock != nil {
                self.finishBlock?()
            }
        }
    }

    /// 检测本地词书是否需要更新
    private func checkLocalBooksStatus(with wordBookDownloadModelList: [YXWordBookDownloadModel]) {
        self.downloadBookCount = 0
        for wordBookDownloadModel in wordBookDownloadModelList {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash else { continue }
            let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId)
            // 本地不存在，或者本地Hash值与后台不一致，则更新
            if (wordBook == nil || wordBook?.bookHash != .some(bookHash)) {
                YXLog("开始下载词书")
                self.downloadBookCount += 1
                self.downloadSingleWordBook(with: bookId, newHash: bookHash)
            }
        }
        // 如果有需要下载的词书
        if downloadBookCount > 0 {
            self.closure?(false)
        } else {
            self.closure?(true)
        }
    }

    /// 下载单本词书
    private func downloadSingleWordBook(with bookId: Int, newHash: String) {
        self.isDownloading = true
        YXLog("下载词书， BookID：\(bookId)", "newHash:", newHash)
        let request = YXWordBookRequest.getBookWord(bookId: bookId)
        YYNetworkService.default.request(YYStructResponse<YXWordBookModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, var bookModel = response.data else {
                return
            }
            bookModel.bookHash = newHash
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.saveBook(with: bookModel)
                self.saveWords(with: bookModel)
            }
            self.downloadBookCount    -= 1
            if self.downloadBookCount == 0 {
                self.isDownloading = false
                self.finishBlock?()
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    // TODO: ---- 本地词书数据库操作 ----

    /// 保存、更新词书
    private func saveBook(with bookModel: YXWordBookModel) {
        guard let bookId = bookModel.bookId else { return }
        /// 删除旧数据
        YXWordBookDaoImpl().deleteBook(bookId: bookId, async: true)
        YXWordBookDaoImpl().insertBook(book: bookModel, async: true)
    }

    /// 保存、更新单词
    private func saveWords(with bookModel: YXWordBookModel) {
        guard let unitsList = bookModel.units, let bookId = bookModel.bookId else {
            return
        }
        /// 删除旧数据
         YXWordBookDaoImpl().deleteWord(bookId: bookId, async: true)
        /// 赋值自定义数据
        for unitModel in unitsList {
            guard let wordsList = unitModel.words else {
                continue
            }
            for var wordModel in wordsList {
                wordModel.gradeId   = bookModel.gradeId
                wordModel.gardeType = bookModel.gradeType ?? 1
                wordModel.bookId    = bookModel.bookId
                wordModel.unitId    = unitModel.unitId
                wordModel.unitName  = unitModel.unitName
                wordModel.isExtensionUnit = unitModel.isExtensionUnit
                YXWordBookDaoImpl().insertWord(word: wordModel, async: true)
            }
        }
    }
}

