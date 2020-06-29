//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import FMDB

class YXExerciseDaoImpl: YYDatabase, YXExerciseDao {
    
    func insertExercise(learn type: YXLearnType, study id: Int, word model: YXWordModel, next step: String) -> Int {
        
        let sql = YYSQLManager.ExerciseSQL.insertExercise.rawValue
        let params: [Any] = [
            id,
            type.rawValue,
            model.wordId as Any,
            model.word as Any,
            model.bookId as Any,
            model.unitId as Any,
            model.wordType.rawValue as Any,
            step as Any
        ]
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        return result ? Int(self.wordRunner.lastInsertRowId) : 0
    }

    func getNewWordList(study id: Int) -> [YXWordModel] {
        var wordModelList = [YXWordModel]()
        let sql = YYSQLManager.ExerciseSQL.getNewWordList.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return wordModelList
        }
        while result.next(){
            let model = self.transformWordModel(result: result)
            wordModelList.append(model)
        }
        result.close()
        return wordModelList
    }

    func getReviewWordList(study id: Int) -> [YXWordModel] {
        var wordModelList = [YXWordModel]()
        let sql = YYSQLManager.ExerciseSQL.getReviewWordList.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return wordModelList
        }
        while result.next() {
            let model = self.transformWordModel(result: result)
            wordModelList.append(model)
        }
        result.close()
        return wordModelList
    }

    func getAllWordExerciseAmount(study id: Int) -> Int {
        var amount = 0
        let sql = YYSQLManager.ExerciseSQL.getAllWordExerciseAmount.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return amount
        }
        if result.next() {
            amount = Int(result.int(forColumn: "amount"))
        }
        return amount
    }

    func updateNextStep(exercise id: Int, next step: String) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateNextStep.rawValue
        let params: [Any] = [step as Any, id as Any]
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        return result
    }

    func updateScore(exercise id: Int, reduce score: Int) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateScore.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [score, score, id])
    }

    func getAllExerciseList(study id: Int) -> [YXExerciseReportModel] {
        var modelList = [YXExerciseReportModel]()
        let sql = YYSQLManager.ExerciseSQL.getAllExercise.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return modelList
        }
        while result.next() {
            let model = self.transformReportModel(result: result)
            modelList.append(model)
        }
        result.close()
        return modelList
    }

    func getFinishedNewWordAmount(study id: Int) -> Int {
        var amount = 0
        let sql = YYSQLManager.ExerciseSQL.getFinishedWordsAmount.rawValue
        let params: [Any] = [1, id]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            amount = Int(result.int(forColumn: "count"))
            result.close()
        }
        return amount
    }

    func getFinishedReviewWordAmount(study id: Int) -> Int {
                var amount = 0
        let sql = YYSQLManager.ExerciseSQL.getFinishedWordsAmount.rawValue
        let params: [Any] = [0, id]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            amount = Int(result.int(forColumn: "count"))
            result.close()
        }
        return amount
    }

    func deleteExercise(study id: Int) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteExerciseWithStudy.rawValue
        let params: [Any] = [id]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    @discardableResult
    func deleteExpiredExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteExpiredExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func deleteAllExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteAllExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }

    // MARK: ==== Tools ====
    /// 转换练习模型
    private func transformReportModel(result: FMResultSet) -> YXExerciseReportModel {
        var model = YXExerciseReportModel()
        model.wordId = Int(result.int(forColumn: "word_id"))
        model.unitId = Int(result.int(forColumn: "unit_id"))
        model.bookId = Int(result.int(forColumn: "book_id"))
        model.score  = Int(result.int(forColumn: "score"))
        model.exerciseId = Int(result.int(forColumn: "exercise_id"))
        return model
    }

    private func transformWordModel(result: FMResultSet) -> YXWordModel {
        var word = YXWordModel()
        let partOfSpeechAndMeaningsDataString: String! = (result.string(forColumn: "partOfSpeechAndMeanings") ?? "[]")
        let deformationsDataString: String!    = (result.string(forColumn: "deformations") ?? "[]")
        let examplessDatStringa: String!       = (result.string(forColumn: "examples") ?? "[]")
        let fixedMatchsDataString: String!     = (result.string(forColumn: "fixedMatchs") ?? "[]")
        let commonPhrasesDataString: String!   = (result.string(forColumn: "commonPhrases") ?? "[]")
        let wordAnalysisDataString: String!    = (result.string(forColumn: "wordAnalysis") ?? "[]")
        let detailedSyntaxsDataString: String! = (result.string(forColumn: "detailedSyntaxs") ?? "[]")
        let synonymsData: Data! = (result.string(forColumn: "synonyms") ?? "[]").data(using: .utf8)!
        let antonymsData: Data! = (result.string(forColumn: "antonyms") ?? "[]").data(using: .utf8)!

        word.wordId                  = Int(result.int(forColumn: "wordId"))
        word.word                    = result.string(forColumn: "word")
        word.partOfSpeechAndMeanings = [YXWordPartOfSpeechAndMeaningModel](JSONString: partOfSpeechAndMeaningsDataString)
        word.imageUrl                = result.string(forColumn: "imageUrl")
        word.americanPhoneticSymbol  = result.string(forColumn: "americanPhoneticSymbol")
        word.englishPhoneticSymbol   = result.string(forColumn: "englishPhoneticSymbol")
        word.americanPronunciation   = result.string(forColumn: "americanPronunciation")
        word.englishPronunciation    = result.string(forColumn: "englishPronunciation")
        word.deformations            = [YXWordDeformationModel](JSONString: deformationsDataString)
        word.examples                = [YXWordExampleModel](JSONString: examplessDatStringa)
        word.fixedMatchs             = [YXWordFixedMatchModel](JSONString: fixedMatchsDataString)
        word.commonPhrases           = [YXWordCommonPhrasesModel](JSONString: commonPhrasesDataString)
        word.wordAnalysis            = [YXWordAnalysisModel](JSONString: wordAnalysisDataString)
        word.detailedSyntaxs         = [YXWordDetailedSyntaxModel](JSONString: detailedSyntaxsDataString)
        word.synonyms                = try? (JSONSerialization.jsonObject(with: synonymsData, options: .mutableContainers) as! [String])
        word.antonyms                = try? (JSONSerialization.jsonObject(with: antonymsData, options: .mutableContainers) as! [String])
        word.gradeId                 = Int(result.int(forColumn: "gradeId"))
        word.gardeType               = Int(result.int(forColumn: "gardeType"))
        word.bookId                  = Int(result.int(forColumn: "bookId"))
        word.unitId                  = Int(result.int(forColumn: "unitId"))
        word.unitName                = result.string(forColumn: "unitName")
        word.isExtensionUnit         = result.bool(forColumn: "isExtensionUnit")

        return word

    }
}
