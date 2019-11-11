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

    
    
    // MARK: - 查询单词
    func fetchWord(by wordID: Int) -> YXWordModel? {
        let fetchRequest: NSFetchRequest<YXCoreWordModel> = YXCoreWordModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wordID == %@", wordID)
        
        do {
            guard let coreWord = try YXCoreDataManager.shared.viewContext.fetch(fetchRequest).first else { return nil }
            
            var word = YXWordModel(map: Map(mappingType: .fromJSON, JSON: ["word_id": coreWord.wordID]))
            word?.word = coreWord.word
            word?.property = coreWord.partOfSpeech
            word?.paraphrase = coreWord.wordSense
            word?.imageUrl = coreWord.imageURL
            word?.synonym = coreWord.synonyms
            word?.antonym = coreWord.antonyms
            word?.soundmarkUS = coreWord.americanPhoneticSymbol
            word?.voiceUS = coreWord.americanPronunciationURL
            word?.soundmarkUK = coreWord.englishPhoneticSymbol
            word?.voiceUK = coreWord.englishPronunciationURL
            word?.usage = coreWord.usages
            word?.examples = [YXWordExampleModel](JSONString: coreWord.examplesJsonString ?? "")
            word?.unitId = Int(coreWord.unitID)
            word?.isExtUnit = coreWord.isBelongExtensionUnit
            word?.bookId = Int(coreWord.wordBook!.bookID)
            word?.gradeId = Int(coreWord.wordBook!.gradeID)

            return word
            
        } catch {
            return nil
        }
    }
    
    
    
    // MARK: - 下载词书
    func download(_ wordBook: YXWordBookModel, with url: URL, closure: ((_ isSuccess: Bool) -> Void)?) {
        self.currentDownloadWordBook = wordBook
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
        guard let url = downloadTask.originalRequest?.url, let bookID = currentDownloadWordBook.bookID else { return }
        
        let downloadedZipURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
        let unzipWordBooksJsonURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("\(bookID)")
        try? FileManager.default.removeItem(at: downloadedZipURL)

        do {
            try FileManager.default.moveItem(at: location, to: downloadedZipURL)
            try Zip.unzipFile(downloadedZipURL, destination: unzipWordBooksJsonURL, overwrite: true, password: nil)
            
            self.saveWordBook(with: unzipWordBooksJsonURL)
            
        } catch {
            DispatchQueue.main.async {
                self.closure?(false)
            }
        }
    }
    
    
    
    // MARK: 保存词书
    private func saveWordBook(with url: URL) {
        let wordBooksJsonUrl = url.appendingPathComponent("words.json")

        do {
            let data = try Data(contentsOf: wordBooksJsonUrl)
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            guard let jsonString = String(data: jsonData, encoding: .unicode), let wordBookSource = YXWordBookSourceModel(JSONString: jsonString), let units = wordBookSource.units else {
                DispatchQueue.main.async {
                    self.closure?(false)
                }
                return
            }
            
            let coreWordBook = YXCoreWordBookModel(context: YXCoreDataManager.shared.viewContext)
            coreWordBook.bookID = Int16(currentDownloadWordBook.bookID!)
            coreWordBook.bookName = currentDownloadWordBook.bookName
            coreWordBook.hashString = currentDownloadWordBook.hashString

            for unit in units {
                guard let words = unit.words else {
                    YXCoreDataManager.shared.viewContext.reset()
                    
                    DispatchQueue.main.async {
                        self.closure?(false)
                    }
                    return
                }
                
                for word in words {
                    let coreWord = YXCoreWordModel(context: YXCoreDataManager.shared.viewContext)
                    coreWord.wordBook = coreWordBook
                    coreWord.wordID = Int16(word.wordId)
                    coreWord.word = word.word
                    coreWord.partOfSpeech = word.property
                    coreWord.wordSense = word.paraphrase
                    coreWord.imageURL = word.imageUrl
                    coreWord.synonyms = word.synonym
                    coreWord.antonyms = word.antonym
                    coreWord.americanPhoneticSymbol = word.soundmarkUS
                    coreWord.americanPronunciationURL = word.voiceUS
                    coreWord.englishPhoneticSymbol = word.soundmarkUK
                    coreWord.englishPronunciationURL = word.voiceUK
                    coreWord.usages = word.usage
                    coreWord.examplesJsonString = word.examples?.toJSONString(prettyPrint: true)
                    coreWord.unitID = Int16(word.unitId)
                    coreWord.isBelongExtensionUnit = word.isExtUnit
                }
            }
          
            try YXCoreDataManager.shared.viewContext.save()
            
            DispatchQueue.main.async {
                self.closure?(true)
            }
            
        } catch {
            DispatchQueue.main.async {
                self.closure?(false)
            }
        }
    }
    
    
    
    // MARK: - 删除词书
    func deleteWordBook(by bookID: Int) {
//        let fetchRequest: NSFetchRequest<YXCoreWordBookModel> = YXCoreWordBookModel.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "bookID == %@", bookID)
//
//        do {
//            guard let coreWordBook = try YXCoreDataManager.shared.viewContext.fetch(fetchRequest).first else { return }
//            YXCoreDataManager.shared.viewContext.delete(coreWordBook)
//            try YXCoreDataManager.shared.viewContext.save()
//
//        } catch {
//            print(error)
//        }
    }
}
