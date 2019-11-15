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
    
    private var urlSession: URLSession!
    private var currentDownloadWordBook: YXWordBookModel!
    private var closure: ((_ isSuccess: Bool) -> Void)?
    
    
    
    // MARK: - 下载词书
    func download(_ wordBook: YXWordBookModel, _ closure: ((_ isSuccess: Bool) -> Void)?) {
        self.currentDownloadWordBook = wordBook
        self.closure = closure
        
        guard let bookID = wordBook.bookId else {
            DispatchQueue.main.async { self.closure?(false) }
            return
        }
        
        YXWordBookDaoImpl().selectBook(bookId: bookID) { (result, isSuccess) in
            if isSuccess, let result = result as? YXWordBookModel, wordBook.bookHash == result.bookHash {
               DispatchQueue.main.async { self.closure?(true) }

            } else {
                let downloadTask = urlSession.downloadTask(with: URL(string: wordBook.bookSource!)!)
                downloadTask.resume()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async { print(calculatedProgress) }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url, let bookID = currentDownloadWordBook.bookId else { return }
        
        let downloadedZipURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
        let unzipWordBooksJsonURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("\(bookID)")
        try? FileManager.default.removeItem(at: downloadedZipURL)
        
        do {
            try FileManager.default.moveItem(at: location, to: downloadedZipURL)
            try Zip.unzipFile(downloadedZipURL, destination: unzipWordBooksJsonURL, overwrite: true, password: nil)
            
            self.saveWordBook(with: unzipWordBooksJsonURL)
            
        } catch {
            DispatchQueue.main.async { self.closure?(false) }
        }
    }
    
    
    
    // MARK: 解析、保存词书
    private func saveWordBook(with url: URL) {
        let wordBooksJsonUrl = url.appendingPathComponent("words.json")
        
        do {
            let data = try Data(contentsOf: wordBooksJsonUrl)
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            guard let jsonString = String(data: jsonData, encoding: .utf8), let wordBook = YXWordBookModel(JSONString: jsonString), let units = wordBook.units else {
                DispatchQueue.main.async { self.closure?(false) }
                return
            }
            
            YXWordBookDaoImpl().insertBook(book: wordBook) { (result, isSuccess) in
                guard isSuccess else {
                    DispatchQueue.main.async { self.closure?(false) }
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
                        
                    }
                }
            }
            
            DispatchQueue.main.async { self.closure?(true) }
            
        } catch {
            DispatchQueue.main.async { self.closure?(false) }
        }
    }
}
