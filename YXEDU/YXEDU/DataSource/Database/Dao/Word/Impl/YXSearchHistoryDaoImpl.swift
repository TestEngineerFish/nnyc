//
//  YXSearchHistoryDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

class YXSearchHistoryDaoImpl: YYDatabase, YXSearchHistoryDao {
    
    func insertWord(word: YXSearchWordModel) -> Bool {
        let sql = YYSQLManager.SearchHistory.insertWord.rawValue
        
        let partOfSpeechAndMeaningsDataString: String! = word.partOfSpeechAndMeanings?.toJSONString() ?? "[]"
        let params: [Any] = [word.wordId ?? 0,
                              word.word ?? "",
                              partOfSpeechAndMeaningsDataString,
                              word.englishPhoneticSymbol ?? "",
                              word.americanPhoneticSymbol ?? "",
                              word.englishPronunciation ?? "",
                              word.americanPronunciation ?? "",
                              word.isComplexWord ?? 0]
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }
    
    func selectWord() -> [YXSearchWordModel] {
        let sql = YYSQLManager.SearchHistory.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return []
        }
        
        var words: [YXSearchWordModel] = []
        while result.next() {
            var word = YXSearchWordModel()
            
            let partOfSpeechAndMeaningsDataString: String! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]")
            
            word.wordId = Int(result.int(forColumn: "wordId"))
            word.word = result.string(forColumn: "word")
            word.partOfSpeechAndMeanings = [YXWordPartOfSpeechAndMeaningModel](JSONString: partOfSpeechAndMeaningsDataString)
            word.americanPhoneticSymbol = result.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result.string(forColumn: "englishPronunciation")
            word.isComplexWord = Int(result.int(forColumn: "isComplexWord"))
            
            words.append(word)
        }
        result.close()
        
        return words
    }
    
    func deleteAllWord() -> Bool {
        let sql = YYSQLManager.SearchHistory.deleteWord.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
}
