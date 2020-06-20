//
//  YXStepConfigDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/21.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStepConfigDaoImpl: YYDatabase, YXStepConfigDao {

    static let share = YXStepConfigDaoImpl()

    func updateTable(_ stepConfigModel: YXStepConfigModel, finished block: ((Bool)->Void)?) {
        let insertSql    = YYSQLManager.OptionConfigSQL.insert.rawValue
        let deleteAllSql = YYSQLManager.OptionConfigSQL.deleteAll.rawValue

        self.wordRunnerQueue.inImmediateTransaction { (db, rollback) in
            let deleteSuccess = db.executeUpdate(deleteAllSql, withArgumentsIn: [])
            if deleteSuccess {
                YXLog("删除本地学习步骤成功")
            } else {
                YXLog("删除本地学习步骤失败")
            }
            for (stepIndex, stepModel) in stepConfigModel.stepList.enumerated() {
                for (wordIndex, wordId) in stepModel.wordIdList.enumerated() {
                    let insertParams: [Any] = [wordId, stepModel.questionType.rawValue, stepModel.wordIdList.sorted().toJson()]
                    let insertSuccess = db.executeUpdate(insertSql, withArgumentsIn: insertParams)
                    if !insertSuccess {
                        YXLog("插入StepConfig失败")
                        block?(false)
                        db.rollback()
                    }
                    if (stepIndex >= stepConfigModel.stepList.count - 1) && (wordIndex >= stepModel.wordIdList.count - 1) {
                        block?(true)
                    }
                }
            }
        }
    }

    func selecte(question type:YXQuestionType, wordId: Int) -> YXStepModel? {
        let sql = YYSQLManager.OptionConfigSQL.seleteBlackList.rawValue
        let params = [type.rawValue as Any, wordId as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var model: YXStepModel?
        var list: Set<Int> = []
        while result.next() {
            model = YXStepModel()
            model?.questionType = YXQuestionType(rawValue: result.string(forColumn: "type") ?? "") ?? .none
            if let listData = (result.string(forColumn: "black_list") ?? "[]").data(using: .utf8) {
                do {
                    let _list = try JSONSerialization.jsonObject(with: listData, options: .mutableLeaves) as? [Int]
                    list.formUnion(Set(_list ?? []))
                } catch {
                    YXLog("数据库读取StepConfig的list失败")
                }
            }
        }
        model?.wordIdList = list
        return model
    }
}
