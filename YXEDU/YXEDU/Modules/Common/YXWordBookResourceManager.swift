//
//  YXWordBookResourceManager.swift
//  YXEDU
//
//  Created by Jake To on 11/7/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import Zip

class YXWordBookResourceManage: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    static let shared = YXWordBookResourceManage()
    private override init() {
        super.init()
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    private var urlSession: URLSession!
    private var currentDownloadBookID = 0
    private var closure: ((_ isSuccess: Bool) -> Void)?

    
    
    // MARK: - 读取词书

    
    
    // MARK: - 下载词书
    func downloadWordBook(with url: URL, and bookID: Int, closure: ((_ isSuccess: Bool) -> Void)?) {
        self.currentDownloadBookID = bookID
        self.closure = closure

        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            print(calculatedProgress)
        }
    }
        
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let destinationURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)

        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            
            let wordBooks = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("WordBooks/\(currentDownloadBookID)")
            try Zip.unzipFile(destinationURL, destination: wordBooks, overwrite: true, password: nil)
            
            DispatchQueue.main.async {
                self.closure?(true)
            }
            
        } catch {
            DispatchQueue.main.async {
                self.closure?(false)
            }
        }
    }
    
    
}
