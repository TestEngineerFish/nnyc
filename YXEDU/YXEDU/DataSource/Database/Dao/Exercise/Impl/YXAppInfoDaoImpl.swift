//
//  YXAppInfoDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXAppInfoDaoImpl: YXBaseExerciseDaoImpl, YXAppInfoDao {

    /// 插入记录
    /// - Parameters:
    ///   - appVersion: App 的版本信息
    ///   - appBuild: App 的Build信息
    ///   - sysVersion: 设备的系统版本
    ///   - remark: 备注
    func insertRecord(appVersion: String, appBuild: String, sysVersion: String, remark: String) {
        let sql    = YYSQLManager.AppInfoSQLs.insertRecord.rawValue
        let params = [appVersion, appBuild, sysVersion, remark]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    /// 获取最后一条记录
    func lastRecord() -> YXAppInfoModel? {
        let sql = YYSQLManager.AppInfoSQLs.lastRecord.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []), result.next() else {
            return nil
        }
        return self.transformModel(result: result)
    }

    /// 获取记录总数
    func recordAmount() -> Int {
        let sql = YYSQLManager.AppInfoSQLs.recordAmount.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []), result.next() else {
            return 0
        }
        return Int(result.int(forColumn: "count"))
    }

    /// 删除旧的记录
    /// - Parameter recordId: 首条记录（低于则删除）
    func deleteOrder(first recordId: Int) {
        let sql = YYSQLManager.AppInfoSQLs.delegetOldRecord.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: [recordId])
    }

    // MARK: ==== Tools ====
    private func transformModel(result: FMResultSet) -> YXAppInfoModel {
        var model = YXAppInfoModel()
        model.id         = Int(result.int(forColumn: "id"))
        model.appVersion = result.string(forColumn: "app_version")
        model.appBuild   = result.string(forColumn: "app_build")
        model.sysVersion = result.string(forColumn: "sys_version")
        model.remark     = result.string(forColumn: "remark")
        return model
    }
}

import ObjectMapper

struct YXAppInfoModel: Mappable {
    var id: Int = 0
    var appVersion: String?
    var appBuild: String?
    var sysVersion: String?
    var remark: String?

    init() {}
    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}
