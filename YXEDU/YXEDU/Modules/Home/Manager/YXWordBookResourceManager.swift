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

class YXWordBookResourceManager: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    static let shared = YXWordBookResourceManager()
    private override init() {
        super.init()
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    private var downloadingWordBookId: Int?
    private var urlSession: URLSession!
    private var currentDownloadWordBook: YXWordBookModel!
    private var closure: ((_ isSuccess: Bool) -> Void)?
    
    
    
    // MARK: - 下载词书
    func download(_ wordBook: YXWordBookModel, _ closure: ((_ isSuccess: Bool) -> Void)?) {
        self.currentDownloadWordBook = wordBook
        self.closure = closure
                
        guard let bookID = wordBook.bookId else {
            self.closure?(false)
            return
        }

        YXWordBookDaoImpl().selectBook(bookId: bookID) { (result, isSuccess) in
            if isSuccess, let result = result as? YXWordBookModel, wordBook.bookHash == result.bookHash {
               self.closure?(true)

            } else {
//                let downloadTask = urlSession.downloadTask(with: URL(string: wordBook.bookSource!)!)
//                downloadingWordBookId = downloadTask.taskIdentifier
//                downloadTask.resume()
                
                YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getbookwords", parameters: ["book_id": wordBook.bookId ?? 0]) { (response, isSuccess) in
                    guard isSuccess, let response = response?.responseObject as? [String: Any] else {
                        self.closure?(false)
                        return
                    }
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        guard let jsonString = String(data: jsonData, encoding: .utf8), let wordBook = YXWordBookModel(JSONString: jsonString) else {
                            self.closure?(false)
                            return
                        }
                        
                        YXWordBookDaoImpl().insertBook(book: wordBook) { (result, isSuccess) in
                            guard isSuccess else {
                                self.closure?(false)
                                return
                            }
                        }
                        
                        guard let units = wordBook.units else {
                            self.closure?(false)
                            return
                        }
                        
                        for unit in units {
                            guard let words = unit.words else { continue }
                            for var word in words {
                                word.gradeId = wordBook.gradeId
                                word.gardeType = wordBook.gradeType
                                word.bookId = wordBook.bookId
                                word.unitId = unit.unitId
                                word.unitName = unit.unitName
                                word.isExtensionUnit = unit.isExtensionUnit
                                
                                YXWordBookDaoImpl().insertWord(word: word)
                            }
                        }
                        
                        self.closure?(true)
                        
                    } catch {
                        print(error)
                        self.closure?(false)
                    }
                }
            }
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
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async { print(calculatedProgress) }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url, let bookID = currentDownloadWordBook.bookId else {
            self.closure?(false)
            return
        }
        
        let downloadedZipURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
        let unzipWordBooksJsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(bookID)")
        try? FileManager.default.removeItem(at: downloadedZipURL)
        
        do {
            try FileManager.default.moveItem(at: location, to: downloadedZipURL)
            try Zip.unzipFile(downloadedZipURL, destination: unzipWordBooksJsonURL, overwrite: true, password: nil)
            
            if downloadTask.taskIdentifier == downloadingWordBookId {
                self.saveWordBook(with: unzipWordBooksJsonURL)
                
            } else {
                self.saveWordBookMaterial(with: unzipWordBooksJsonURL)
            }
            
        } catch {
            self.closure?(false)
        }
    }
    
    
    
    // MARK: 解析、保存词书
    private func saveWordBook(with url: URL) {
        let wordBooksJsonUrl = url.appendingPathComponent("words.json")
        
        do {
            let data = try Data(contentsOf: wordBooksJsonUrl)
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            guard let jsonString = String(data: jsonData, encoding: .utf8), let wordBook = YXWordBookModel(JSONString: jsonString), let units = wordBook.units else {
                self.closure?(false)
                return
            }
            
            YXWordBookDaoImpl().insertBook(book: wordBook) { (result, isSuccess) in
                guard isSuccess else {
                    self.closure?(false)
                    return
                }
            }
            
            for unit in units {
                guard let words = unit.words else { continue }
                for var word in words {
                    word.gradeId = wordBook.gradeId
                    word.gardeType = wordBook.gradeType
                    word.bookId = wordBook.bookId
                    word.unitId = unit.unitId
                    word.unitName = unit.unitName
                    word.isExtensionUnit = unit.isExtensionUnit

                    YXWordBookDaoImpl().insertWord(word: word) { (result, isSuccess) in
                        print(isSuccess)
                    }
                }
            }
            
            self.closure?(true)

        } catch {
            self.closure?(false)
        }
    }
    
    private func saveWordBookMaterial(with url: URL) {
        let wordBooksJsonUrl = url.appendingPathComponent("words.json")

        do {
            let data = try Data(contentsOf: wordBooksJsonUrl)
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            guard let jsonString = String(data: jsonData, encoding: .utf8), let wordBook = YXWordBookModel(JSONString: jsonString), let units = wordBook.units else {
                self.closure?(false)
                return
            }

            for unit in units {
                guard let words = unit.words else { continue }
                for var word in words {
                    word.gradeId = wordBook.gradeId
                    word.gardeType = wordBook.gradeType
                    word.bookId = wordBook.bookId
                    word.unitId = unit.unitId
                    word.unitName = unit.unitName
                    word.isExtensionUnit = unit.isExtensionUnit
                    
                    word.imageUrl = replaceResourceUrl(resourcePath: word.imageUrl, wordBooksResourcePath: url.path)
                    word.americanPronunciation = replaceResourceUrl(resourcePath: word.americanPronunciation, wordBooksResourcePath: url.path)
                    word.englishPronunciation = replaceResourceUrl(resourcePath: word.englishPronunciation, wordBooksResourcePath: url.path)
                    word.examplePronunciation = replaceResourceUrl(resourcePath: word.examplePronunciation, wordBooksResourcePath: url.path)

                    YXWordBookDaoImpl().insertWord(word: word) { (result, isSuccess) in
                        print(isSuccess)
                    }
                }
            }
            
            self.closure?(true)

        } catch {
            self.closure?(false)
        }
    }
    
    private func replaceResourceUrl(resourcePath: String?, wordBooksResourcePath: String) -> String? {
        guard let newPath = resourcePath?.replacingOccurrences(of: "http://cdn.xstudyedu.com", with: wordBooksResourcePath) else { return resourcePath }
        return newPath
    }
}
