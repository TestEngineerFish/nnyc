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
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [word.wordId ?? -1])        
    }
    
    func selectWord() -> [YXSearchWordModel] {
        let sql = YYSQLManager.SearchHistory.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return []
        }
        
        var words: [YXSearchWordModel] = []
        while result.next() {
            var word = YXSearchWordModel()
            
            let partOfSpeechAndMeaningsData: Data! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]").data(using: .utf8)!
            let deformationsData: Data! = (result.string(forColumn: "deformations") ?? "[]").data(using: .utf8)!
            let examplessData: Data! = (result.string(forColumn: "examples") ?? "[]").data(using: .utf8)!
            let fixedMatchsData: Data! = (result.string(forColumn: "fixedMatchs") ?? "[]").data(using: .utf8)!
            let commonPhrasesData: Data! = (result.string(forColumn: "commonPhrases") ?? "[]").data(using: .utf8)!
            let wordAnalysisData: Data! = (result.string(forColumn: "wordAnalysis") ?? "[]").data(using: .utf8)!
            let detailedSyntaxsData: Data! = (result.string(forColumn: "detailedSyntaxs") ?? "[]").data(using: .utf8)!
            let synonymsData: Data! = (result.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
            let antonymsData: Data! = (result.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!
            
            word.wordId = Int(result.int(forColumn: "wordId"))
            word.word = result.string(forColumn: "word")
            word.partOfSpeechAndMeanings = try? (JSONSerialization.jsonObject(with: partOfSpeechAndMeaningsData, options: .mutableContainers) as! [YXWordPartOfSpeechAndMeaningModel])
            word.imageUrl = result.string(forColumn: "imageUrl")
            word.americanPhoneticSymbol = result.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result.string(forColumn: "englishPronunciation")
            word.deformations = try? (JSONSerialization.jsonObject(with: deformationsData, options: .mutableContainers) as! [YXWordDeformationModel])
            word.examples = try? (JSONSerialization.jsonObject(with: examplessData, options: .mutableContainers) as! [YXWordExampleModel])
            word.fixedMatchs = try? (JSONSerialization.jsonObject(with: fixedMatchsData, options: .mutableContainers) as! [YXWordFixedMatchModel])
            word.commonPhrases = try? (JSONSerialization.jsonObject(with: commonPhrasesData, options: .mutableContainers) as! [YXWordCommonPhrasesModel])
            word.wordAnalysis = try? (JSONSerialization.jsonObject(with: wordAnalysisData, options: .mutableContainers) as! [YXWordAnalysisModel])
            word.detailedSyntaxs = try? (JSONSerialization.jsonObject(with: detailedSyntaxsData, options: .mutableContainers) as! [YXWordDetailedSyntaxModel])
            word.synonyms = try? (JSONSerialization.jsonObject(with: synonymsData, options: .mutableContainers) as! [String])
            word.antonyms = try? (JSONSerialization.jsonObject(with: antonymsData, options: .mutableContainers) as! [String])
            word.gradeId = Int(result.int(forColumn: "gradeId"))
            word.gardeType = Int(result.int(forColumn: "gardeType"))
            word.bookId = Int(result.int(forColumn: "bookId"))
            word.unitId = Int(result.int(forColumn: "unitId"))
            word.unitName = result.string(forColumn: "unitName")
            word.isExtensionUnit = result.bool(forColumn: "isExtensionUnit")
            
            words.append(word)
        }
        result.close()
        
        return words
    }
    
    
}
