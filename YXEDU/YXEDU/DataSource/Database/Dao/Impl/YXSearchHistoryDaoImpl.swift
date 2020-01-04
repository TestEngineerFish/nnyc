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
            
            let partOfSpeechAndMeaningsDataString: String! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]")
            let deformationsDataString: String! = (result.string(forColumn: "deformations") ?? "[]")
            let examplessDatStringa: String! = (result.string(forColumn: "examples") ?? "[]")
            let fixedMatchsDataString: String! = (result.string(forColumn: "fixedMatchs") ?? "[]")
            let commonPhrasesDataString: String! = (result.string(forColumn: "commonPhrases") ?? "[]")
            let wordAnalysisDataString: String! = (result.string(forColumn: "wordAnalysis") ?? "[]")
            let detailedSyntaxsDataString: String! = (result.string(forColumn: "detailedSyntaxs") ?? "[]")
            let synonymsData: Data! = (result.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
            let antonymsData: Data! = (result.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!
            
            word.wordId = Int(result.int(forColumn: "wordId"))
            word.word = result.string(forColumn: "word")
            word.partOfSpeechAndMeanings = [YXWordPartOfSpeechAndMeaningModel](JSONString: partOfSpeechAndMeaningsDataString)
            word.imageUrl = result.string(forColumn: "imageUrl")
            word.americanPhoneticSymbol = result.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result.string(forColumn: "englishPronunciation")
            word.deformations = [YXWordDeformationModel](JSONString: deformationsDataString)
            word.examples = [YXWordExampleModel](JSONString: examplessDatStringa)
            word.fixedMatchs = [YXWordFixedMatchModel](JSONString: fixedMatchsDataString)
            word.commonPhrases = [YXWordCommonPhrasesModel](JSONString: commonPhrasesDataString)
            word.wordAnalysis = [YXWordAnalysisModel](JSONString: wordAnalysisDataString)
            word.detailedSyntaxs = [YXWordDetailedSyntaxModel](JSONString: detailedSyntaxsDataString)
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
    
    func deleteAllWord() -> Bool {
        let sql = YYSQLManager.SearchHistory.deleteWord.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
}
