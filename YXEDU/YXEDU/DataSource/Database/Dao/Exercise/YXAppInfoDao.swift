//
//  YXAppInfoDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXAppInfoDao {

    /// 插入记录
    /// - Parameters:
    ///   - appVersion: App 的版本信息
    ///   - appBuild: App 的Build信息
    ///   - sysVersion: 设备的系统版本
    ///   - remark: 备注
    func insertRecord(appVersion: String, appBuild: String, sysVersion: String, remark: String)

    /// 获取最后一条记录
    func lastRecord() -> YXAppInfoModel?

    /// 获取记录总数
    func recordAmount() -> Int

    /// 删除旧的记录
    /// - Parameter recordId: 首条记录（低于则删除）
    func deleteOrder(first recordId: Int)

}
