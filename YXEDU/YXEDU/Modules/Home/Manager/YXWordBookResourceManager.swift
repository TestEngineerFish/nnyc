//
//  YXWordBookResourceManager.swift
//  YXEDU
//
//  Created by Jake To on 11/7/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
import Zip

class YXWordBookResourceManager: NSObject, URLSessionTaskDelegate {
    static let shared = YXWordBookResourceManager()
    private override init() {
        super.init()
    }
    
    private var isDownloading = false
    private var closure: ((_ isSuccess: Bool) -> Void)?
    

    // MARK: - 下载词书
    func contrastBookData(by bookId: Int? = nil, _ closure: ((_ isSuccess: Bool) -> Void)? = nil, showToast: Bool = false) {
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
                            self.checkLocalBookStatus(with: [wordBookDownloadModel], showToast: showToast)
                        }
                    }
                } else {
                    self.checkLocalBookStatus(with: wordBookDownloadModels)
                }
            } else {
                closure?(false)
            }
        }) { error in
            print("❌❌❌\(error)")
        }
    }

    /// 检测本地词书是否需要更新
    private func checkLocalBookStatus(with wordBookDownloadModelList: [YXWordBookDownloadModel], showToast: Bool = false) {
        var isShowWarning = false
        for wordBookDownloadModel in wordBookDownloadModelList {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash, let downloadUrl = wordBookDownloadModel.downloadUrl, downloadUrl.isEmpty == false else { continue }
            let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId)
            // 本地不存在，或者本地Hash值与后台不一致，则更新
            if (wordBook == nil || wordBook?.bookHash != .some(bookHash)) {
                /// 需要更新
                if !isShowWarning {
                    YXUtils.showProgress(kWindow, info: "正在下载词书，请稍后再试～")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        YXUtils.hidenProgress(kWindow)
                    }
                }
                isShowWarning = true
                print("更新啦")
                DispatchQueue.global().async {
                    self.downloadSingleWordBook(with: bookId, newHash: bookHash)
                }
            }
        }
        
        // 如果没有需要更新的，则执行闭包函数
        if !isShowWarning && showToast {
            self.closure?(true)
        }
    }

    /// 下载单本词书
    private func downloadSingleWordBook(with bookId: Int, newHash: String) {
        let request = YXWordBookRequest.getBookWord(bookId: bookId)
        YYNetworkService.default.request(YYStructResponse<YXWordBookModel>.self, request: request, success: { (response) in
            guard var bookModel = response.data else {
                return
            }
            bookModel.bookHash = newHash
            self.saveBook(with: bookModel)
            self.saveWords(with: bookModel)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: "\(error.message)")
        }
    }

    /// 保存、更新词书
    private func saveBook(with bookModel: YXWordBookModel) {
        guard let bookId = bookModel.bookId else { return }
        /// 删除旧数据
        let result = YXWordBookDaoImpl().deleteBook(bookId: bookId)
        if result {
            print("删除词书成功🙆‍♂️")
        }
        let isSuccess = YXWordBookDaoImpl().insertBook(book: bookModel)
        if isSuccess {
            print("====更新词书成功🙆‍♂️===")
        } else {
            print("====更新词书失败🙆‍♂️===")
        }
    }

    /// 保存、更新单词
    private func saveWords(with bookModel: YXWordBookModel) {
        guard let unitsList = bookModel.units, let bookId = bookModel.bookId else {
            return
        }
        /// 删除旧数据
         let result = YXWordBookDaoImpl().deleteWord(bookId: bookId)
         if result {
             print("删除词书单词成功🙆")
         }
        /// 赋值自定义数据
        for unitModel in unitsList {
            guard let wordsList = unitModel.words else {
                continue
            }
            for var wordModel in wordsList {
                wordModel.gradeId   = bookModel.gradeId
                wordModel.gardeType = bookModel.gradeType
                wordModel.bookId    = bookModel.bookId
                wordModel.unitId    = unitModel.unitId
                wordModel.unitName  = unitModel.unitName
                wordModel.isExtensionUnit = unitModel.isExtensionUnit
                let isSuccess = YXWordBookDaoImpl().insertWord(word: wordModel)
                if isSuccess {
                    print("====更新单词成功🙆===")
                } else {
                    print("====更新单词失败🙆===")
                }
            }
        }
    }
}

