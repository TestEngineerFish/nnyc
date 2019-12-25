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
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    private var isDownloading = false
    private var urlSession: URLSession!
    private var closure: ((_ isSuccess: Bool) -> Void)?
    
    
    
    // MARK: - 下载词书
    func download(by bookId: Int? = nil, _ closure: ((_ isSuccess: Bool) -> Void)? = nil) {
        guard isDownloading == false else { return }
        
        let request = YXWordBookRequest.downloadWordBook(bookId: bookId)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordBookDownloadModel>.self, request: request, success: { (response) in
            if let wordBookDownloadModels = response.dataArray {
                if let bookId = bookId {
                    for wordBookDownloadModel in wordBookDownloadModels {
                        if wordBookDownloadModel.id == bookId {
                            self.closure = closure
                            self.downloadSingleWordBook(from: wordBookDownloadModel)
                            break
                        }
                    }
                    
                } else {
                    self.closure = closure
                    self.downloadAllUndownloadWordBook(from: wordBookDownloadModels)
                }
                
            } else {
                closure?(false)
            }
            
        }, fail: { error in
            closure?(false)
        })
    }
    
    private func downloadSingleWordBook(from wordBookDownloadModel: YXWordBookDownloadModel) {
        guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash, let downloadUrl = wordBookDownloadModel.downloadUrl else { return }
        
        if let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId), wordBook.bookHash == bookHash {
            self.closure?(true)
            
        } else {
            self.isDownloading = true

            let downloadUrl = URL(string: downloadUrl)!
            let downloadTask = self.urlSession.downloadTask(with: downloadUrl) { (loaction, response, error) in
                guard let loaction = loaction else { return }
                let isSuccess = self.unzipDownloadFile(url: downloadUrl, location: loaction, identifier: bookHash)
                
                DispatchQueue.main.async {
                    self.isDownloading = false
                    self.closure?(isSuccess)
                }
            }
            
            downloadTask.resume()
        }
    }
    
    private func downloadAllUndownloadWordBook(from allWordBookDownloadModels: [YXWordBookDownloadModel]) {
        var didFinishAllDownload = true
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        for wordBookDownloadModel in allWordBookDownloadModels {
            guard let bookId = wordBookDownloadModel.id, let bookHash = wordBookDownloadModel.hash, let downloadUrl = wordBookDownloadModel.downloadUrl else { return }
            
            if let wordBook = YXWordBookDaoImpl().selectBook(bookId: bookId), wordBook.bookHash == bookHash {
                queue.async(group: group) {

                }
                
            } else {
                queue.async(group: group) {
                    self.isDownloading = true

                    let downloadUrl = URL(string: downloadUrl)!
                    let downloadTask = self.urlSession.downloadTask(with: downloadUrl) { (loaction, response, error) in
                        guard let loaction = loaction else { return }
                        let isSuccess = self.unzipDownloadFile(url: downloadUrl, location: loaction, identifier: bookHash)
                        didFinishAllDownload = isSuccess
                    }
                    
                    downloadTask.resume()
                }
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.isDownloading = false
                self.closure?(didFinishAllDownload)
            }
        }
    }

    private func unzipDownloadFile(url: URL, location: URL, identifier: String) -> Bool {
        let zipUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: zipUrl)
        
        do {
            try FileManager.default.moveItem(at: location, to: zipUrl)
            
            let unzipUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("\(identifier)/")
            try Zip.unzipFile(zipUrl, destination: unzipUrl, overwrite: true, password: nil)
            
            return self.saveWordBook(from: unzipUrl, with: identifier)
            
        } catch {
            return false
        }
    }
    
    private func saveWordBook(from jsonUrl: URL, with identifier: String) -> Bool {
        do {
            let jsonData = try Data(contentsOf: jsonUrl.appendingPathComponent("word.json"))
            guard let jsonString = String(data: jsonData, encoding: .utf8), var wordBook = YXWordBookModel(JSONString: jsonString), let units = wordBook.units else { return false }
            wordBook.bookHash = identifier
            
            let isSuccess = YXWordBookDaoImpl().insertBook(book: wordBook)
            guard isSuccess else { return false }
            
            for unit in units {
                guard let words = unit.words else { continue }
                for var word in words {
                    word.gradeId = wordBook.gradeId
                    word.gardeType = wordBook.gradeType
                    word.bookId = wordBook.bookId
                    word.unitId = unit.unitId
                    word.unitName = unit.unitName
                    word.isExtensionUnit = unit.isExtensionUnit

                    let isSuccess = YXWordBookDaoImpl().insertWord(word: word)
                    guard isSuccess else { return false }
                }
            }
            
            return true
                        
        } catch {
            return false
        }
    }
    
    
    func downloadMaterial(in wordBook: YXWordBookModel, _ closure: ((_ isSuccess: Bool) -> Void)?) {
//        guard let bookID = wordBook.bookId else {
//            self.closure?(false)
//            return
//        }
//
//        YXWordBookDaoImpl().selectBook(bookId: bookID) { (result, isSuccess) in
//            if isSuccess, let result = result as? YXWordBookModel, wordBook.bookHash == result.bookHash {
//                self.closure?(false)
//
//            } else {
//                let downloadTask = urlSession.downloadTask(with: URL(string: wordBook.bookSourcePath!)!)
//                downloadTask.resume()
//            }
//        }
    }
    
    private func saveWordBookMaterial(with url: URL) {
//        let wordBooksJsonUrl = url.appendingPathComponent("words.json")
//
//        do {
//            let data = try Data(contentsOf: wordBooksJsonUrl)
//            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//            guard let jsonString = String(data: jsonData, encoding: .utf8), let wordBook = YXWordBookModel(JSONString: jsonString), let units = wordBook.units else {
//                self.closure?(false)
//                return
//            }
//
//            for unit in units {
//                guard let words = unit.words else { continue }
//                for var word in words {
//                    word.gradeId = wordBook.gradeId
//                    word.gardeType = wordBook.gradeType
//                    word.bookId = wordBook.bookId
//                    word.unitId = unit.unitId
//                    word.unitName = unit.unitName
//                    word.isExtensionUnit = unit.isExtensionUnit
//
//                    word.imageUrl = replaceResourceUrl(resourcePath: word.imageUrl, wordBooksResourcePath: url.path)
//                    word.americanPronunciation = replaceResourceUrl(resourcePath: word.americanPronunciation, wordBooksResourcePath: url.path)
//                    word.englishPronunciation = replaceResourceUrl(resourcePath: word.englishPronunciation, wordBooksResourcePath: url.path)
//                    word.examplePronunciation = replaceResourceUrl(resourcePath: word.examplePronunciation, wordBooksResourcePath: url.path)
//
//                    YXWordBookDaoImpl().insertWord(word: word) { (result, isSuccess) in
//                        print(isSuccess)
//                    }
//                }
//            }
//
//            self.closure?(true)
//
//        } catch {
//            self.closure?(false)
//        }
//    }
//
//    private func replaceResourceUrl(resourcePath: String?, wordBooksResourcePath: String) -> String? {
//        guard let newPath = resourcePath?.replacingOccurrences(of: "http://cdn.xstudyedu.com", with: wordBooksResourcePath) else { return resourcePath }
//        return newPath
    }
}
