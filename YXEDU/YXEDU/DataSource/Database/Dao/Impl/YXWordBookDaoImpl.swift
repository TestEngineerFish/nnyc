//
//  YXWordDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

class YXWordBookDaoImpl: YYDatabase, YXWordBookDao {

    func insertBook(book: YXWordBookModel, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.insertBook.rawValue
        let params: [Any?] = [book.bookId,
                             book.bookName,
                             book.bookJsonSourcePath,
                             book.bookHash,
                             book.gradeId,
                             book.gradeType]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params as [Any])
            completion?(nil, isSuccess)
        }
    }
    
    func selectBook(bookId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let result = db.executeQuery(sql, withArgumentsIn: params)
            var book = YXWordBookModel()
            
            book.bookId = Int(result?.int(forColumn: "bookId") ?? 0)
            book.bookName = result?.string(forColumn: "bookName")
            book.bookJsonSourcePath = result?.string(forColumn: "bookSource")
            book.bookHash = result?.string(forColumn: "bookHash")
            book.gradeId = Int(result?.int(forColumn: "gradeId") ?? 0)
            book.gradeType = Int(result?.int(forColumn: "gradeType") ?? 0)

            result?.close()

            let isSuccess = result?.next() ?? false
            completion(isSuccess ? book : nil, isSuccess)
        }
    }
    
    func deleteBook(bookId: Int, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.deleteBook.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    func insertWord(word: YXWordModel, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.insertWord.rawValue
        let partOfSpeechAndMeaningsData: Data! = try? JSONSerialization.data(withJSONObject: word.partOfSpeechAndMeanings ?? [])
        let deformationsData: Data! = try? JSONSerialization.data(withJSONObject: word.deformations ?? [])
        let examplessData: Data! = try? JSONSerialization.data(withJSONObject: word.examples ?? [])
        let fixedMatchsData: Data! = try? JSONSerialization.data(withJSONObject: word.fixedMatchs ?? [])
        let commonPhrasesData: Data! = try? JSONSerialization.data(withJSONObject: word.commonPhrases ?? [])
        let wordAnalysisData: Data! = try? JSONSerialization.data(withJSONObject: word.wordAnalysis ?? [])
        let detailedSyntaxsData: Data! = try? JSONSerialization.data(withJSONObject: word.detailedSyntaxs ?? [])
        let synonymsData: Data! = try? JSONSerialization.data(withJSONObject: word.synonyms ?? [])
        let antonymsData: Data! = try? JSONSerialization.data(withJSONObject: word.antonyms ?? [])

        let params: [Any?] = [word.wordId,
                              word.word,
                              String(data: partOfSpeechAndMeaningsData!, encoding: .utf8),
                              word.imageUrl,
                              word.englishPhoneticSymbol,
                              word.americanPhoneticSymbol,
                              word.englishPronunciation,
                              word.americanPronunciation,
                              String(data: deformationsData!, encoding: .utf8),
                              String(data: examplessData!, encoding: .utf8),
                              String(data: fixedMatchsData!, encoding: .utf8),
                              String(data: commonPhrasesData!, encoding: .utf8),
                              String(data: wordAnalysisData!, encoding: .utf8),
                              String(data: detailedSyntaxsData!, encoding: .utf8),
                              String(data: synonymsData!, encoding: .utf8),
                              String(data: antonymsData!, encoding: .utf8),
                              word.gradeId,
                              word.gardeType,
                              word.bookId,
                              word.unitId ,
                              word.unitName,
                              word.isExtensionUnit]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    func selectWord(wordId: Int, completion: finishBlock) {
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        let params: [Any] = [wordId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            var word = YXWordModel()

            let result = db.executeQuery(sql, withArgumentsIn: params)
            let partOfSpeechAndMeaningsData: Data! = (result?.string(forColumn: "partOfSpeechAndMeanings") ?? "[]").data(using: .utf8)!
            let deformationsData: Data! = (result?.string(forColumn: "deformations") ?? "[]").data(using: .utf8)!
            let examplessData: Data! = (result?.string(forColumn: "examples") ?? "[]").data(using: .utf8)!
            let fixedMatchsData: Data! = (result?.string(forColumn: "fixedMatchs") ?? "[]").data(using: .utf8)!
            let commonPhrasesData: Data! = (result?.string(forColumn: "commonPhrases") ?? "[]").data(using: .utf8)!
            let wordAnalysisData: Data! = (result?.string(forColumn: "wordAnalysis") ?? "[]").data(using: .utf8)!
            let detailedSyntaxsData: Data! = (result?.string(forColumn: "detailedSyntaxs") ?? "[]").data(using: .utf8)!
            let synonymsData: Data! = (result?.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
            let antonymsData: Data! = (result?.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!
            
            word.wordId = Int(result?.int(forColumn: "wordId") ?? 0)
            word.word = result?.string(forColumn: "word")
            word.partOfSpeechAndMeanings = try? (JSONSerialization.jsonObject(with: partOfSpeechAndMeaningsData, options: .mutableContainers) as! [YXWordPartOfSpeechAndMeaningModel])
            word.imageUrl = result?.string(forColumn: "imageUrl")
            word.americanPhoneticSymbol = result?.string(forColumn: "americanPhoneticSymbol")
            word.englishPhoneticSymbol = result?.string(forColumn: "englishPhoneticSymbol")
            word.americanPronunciation = result?.string(forColumn: "americanPronunciation")
            word.englishPronunciation = result?.string(forColumn: "englishPronunciation")
            word.deformations = try? (JSONSerialization.jsonObject(with: deformationsData, options: .mutableContainers) as! [YXWordDeformationModel])
            word.examples = try? (JSONSerialization.jsonObject(with: examplessData, options: .mutableContainers) as! [YXWordExampleModel])
            word.fixedMatchs = try? (JSONSerialization.jsonObject(with: fixedMatchsData, options: .mutableContainers) as! [YXWordFixedMatchModel])
            word.commonPhrases = try? (JSONSerialization.jsonObject(with: commonPhrasesData, options: .mutableContainers) as! [YXWordCommonPhrasesModel])
            word.wordAnalysis = try? (JSONSerialization.jsonObject(with: wordAnalysisData, options: .mutableContainers) as! [YXWordAnalysisModel])
            word.detailedSyntaxs = try? (JSONSerialization.jsonObject(with: detailedSyntaxsData, options: .mutableContainers) as! [YXWordDetailedSyntaxModel])
            word.synonyms = try? (JSONSerialization.jsonObject(with: synonymsData, options: .mutableContainers) as! [String])
            word.antonyms = try? (JSONSerialization.jsonObject(with: antonymsData, options: .mutableContainers) as! [String])
            word.gradeId = Int(result?.int(forColumn: "gradeId") ?? 0)
            word.gardeType = Int(result?.int(forColumn: "gardeType") ?? 0)
            word.bookId = Int(result?.int(forColumn: "bookId") ?? 0)
            word.unitId = Int(result?.int(forColumn: "unitId") ?? 0)
            word.unitName = result?.string(forColumn: "unitName")
            word.isExtensionUnit = result?.bool(forColumn: "isExtensionUnit") ?? false
            
            result?.close()

            let isSuccess = result?.next() ?? false
            completion(isSuccess ? word : nil, isSuccess)
        }
    }
    
    func selectWordByUnitId(unitId: Int) -> [YXWordModel] {
        let sql = YYSQLManager.WordBookSQL.selectWordByUnitId.rawValue
        let params: [Any] = [unitId]
        var wordModelArray = [YXWordModel]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return wordModelArray
        }

        while result.next() {
            var word = YXWordModel()
            
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
            
            wordModelArray.append(word)
        }
        
        result.close()
        return wordModelArray
    }

    func selectWordByBookId(_ bookId: Int) -> [YXWordModel] {
        let sql = YYSQLManager.WordBookSQL.selectWordByBookId.rawValue
        let params: [Any] = [bookId]
        var wordModelArray = [YXWordModel]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return wordModelArray
        }

        while result.next() {
            var word = YXWordModel()
            
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

            wordModelArray.append(word)
        }

        result.close()
        return wordModelArray
    }
    
    func deleteWord(bookId: Int, completion: finishBlock? = nil) {
        let sql = YYSQLManager.WordBookSQL.deleteWord.rawValue
        let params: [Any] = [bookId]
        
        self.wordRunnerQueue.inDatabase { (db) in
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: params)
            completion?(nil, isSuccess)
        }
    }
    
    
    func selectWord(wordId: Int) -> YXWordModel? {
        let json = """
                 {
                     "word_id": 1,
                     "word": "good",
                     "word_image": "http://cdn.xstudyedu.com/res/rj_1/middle/good/1570699002.jpg",
                     "symbol_us": "美/ɡʊd/",
                     "symbol_uk": "英/gʊd/",
                     "voice_us": "http://cdn.xstudyedu.com/res/rj_1/voice/good_us.mp3",
                     "voice_uk": "http://cdn.xstudyedu.com/res/rj_1/voice/good_uk.mp3",
                     "word_syllables": "good",
                     "synonym": [
                         "great",
                         "helpful"
                     ],
                     "antonym": [
                         "poor",
                         "bad"
                     ],
                     "usage": [
                         "adj.+n.  good health 身体健康",
                         "v.+adj.  look good 看起来不错"
                     ],
                     "paraphrase": [{
                         "k": "adj.",
                         "v": "好的"
                     }],
                     "examples": [{
                         "en": "You have such a <font color='#55a7fd'>good</font> chance.",
                         "cn": "你有这么一个好的机会。",
                         "voice": "http://cdn.xstudyedu.com/res/rj_1/speech/a00c5c2830ffc50a68f820164827f356.mp3",
                         "image": "http://cdn.xstudyedu.com/res/rj_1/middle/good/1570699002.jpg"
                     }],
                     "vary": [{
                             "k": "最高级",
                             "v": "best"
                         },
                         {
                             "k": "比较级",
                             "v": "better"
                         }
                     ],
                     "hold_match": [{
                             "match_en": "spend sth on sth",
                             "match_cn": "在……上花费",
                             "example_en": "More money should be spent on education.",
                             "example_cn": "更多的钱应该花在教育上。"
                         },
                         {
                             "match_en": "spend sth (in) doing sth",
                             "match_cn": "花费…去做某事",
                             "example_en": "I spend all my free time (in) painting.",
                             "example_cn": "我在画画上花费了我所有的空闲时间。"
                         }
                     ],
                     "common_short": [{
                             "k": "in air",
                             "v": "在空中"
                         },
                         {
                             "k": "on the air",
                             "v": "穿上盛装的，精心打扮的"
                         }
                     ],
                     "analysis": [{
                         "title": "through & across",
                         "list": [
                             "through用做介词。\"表示从物体里面穿过。",
                             " across 用做介词。表示在一个物体的表面上穿过。"
                         ]
                     }],
                     "grammar": [{
                             "title": "反身代词",
                             "list": [
                                 "第一人称—我自己/我们自己—myself/ourselves ",
                                 "第二人称—你自己/你们自己—yourself/yourselves ",
                                 "第三人称—他/她/它/他们自己—himself/herself/ itself/themselves"
                             ]
                         },
                         {
                             "title": "频率副词",
                             "list": [
                                 "第一人称—我自己/我们自己—myself/ourselves ",
                                 "第二人称—你自己/你们自己—yourself/yourselves ",
                                 "第三人称—他/她/它/他们自己—himself/herself/ itself/themselves"
                             ]
                         }
                     ],

                     "msg": "",
                     "time": 1575893582
                 }

                 """
                 
                 
        var word = YXWordModel(JSONString: json)
        word?.wordId = wordId
        //        word?.word = (word?.word ?? "") + "\(wordId)"
        return word
        
        
        
        let sql = YYSQLManager.WordBookSQL.selectWord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [wordId]) else {
//            DDLogError("selectRecordByImageID failed")
            return nil
        }
        
        if result.next() {
            var word = YXWordModel()
            
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
            
            return word
        }
        result.close()
        return nil
        
//        let json = """
//        {
//            "word_id" : 1,
//            "word" : "overnight",
//            "word_property" : "adv",
//            "word_paraphrase" : "在晚上, 在夜里",
//            "word_image" : "http://static.51jiawawa.com/images/goods/20181114165122185.png",
//            "symbol_us" : "美/ɡʊd/",
//            "symbol_uk" : "英/ɡʊd/",
//            "voice_us" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "voice_uk" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "example_en" : "You have such a <font color='#55a7fd'>good</font> chance.",
//            "example_cn" : "你有这么一个好的机会。",
//            "example_voice": "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
//            "synonym": "great,helpful",
//            "antonym": "poor,bad",
//            "usage":  ["adj.+n.  early morning 清晨","n.+n.  morning exercise早操"]
//        }
//        """
//
//
//        var word = YXWordModel(JSONString: json)
//        word?.wordId = wordId
//        word?.gradeId = 1
//        //        word?.word = (word?.word ?? "") + "\(wordId)"
//        return word
    }
}
