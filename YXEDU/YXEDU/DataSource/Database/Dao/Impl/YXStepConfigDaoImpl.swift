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
        let insertSql    = YYSQLManager.StepConfigSQL.insert.rawValue
        let deleteAllSql = YYSQLManager.StepConfigSQL.deleteAll.rawValue

        self.wordRunnerQueue.inTransaction { (db, rollback) in
            let deleteSuccess = db.executeUpdate(deleteAllSql, withArgumentsIn: [])
            if deleteSuccess {
                YXLog("删除本地学习步骤成功")
            } else {
                YXLog("删除本地学习步骤失败")
            }
            for (stepIndex, stepModel) in stepConfigModel.stepList.enumerated() {
                for (wordIndex, wordId) in stepModel.wordIdList.enumerated() {
                    let insertParams: [Any] = [wordId, stepModel.step, stepModel.wordIdList.toJson()]
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


    func selecte(step: Int, wordId: Int) -> YXStepModel? {
        let sql = YYSQLManager.StepConfigSQL.seleteBlackList.rawValue
        let params = [step, wordId]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var model: YXStepModel?
        if result.next() {
            model = YXStepModel()
            model?.step = Int(result.int(forColumn: "step"))
            if let listData = (result.string(forColumn: "black_list") ?? "[]").data(using: .utf8) {
                do {
                    let list = try JSONSerialization.jsonObject(with: listData, options: .mutableLeaves) as? [Int]
                    model?.wordIdList = list ?? []
                } catch {
                    model?.wordIdList = []
                }
            }
        }
        return model
    }
}
