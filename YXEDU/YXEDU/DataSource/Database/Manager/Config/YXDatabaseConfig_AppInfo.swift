//
//  YXDatabaseConfig+AppInfo.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {

    enum AppInfoSQLs: String {
        /// 插入一条记录
        case insertRecord =
        """
        INSERT INTO
        app_info(
            app_version,
            app_build,
            sys_version,
            remark
        )
        VALUES(?, ?, ?, ?)
        """
        /// 获取最后一条记录
        case lastRecord =
        """
        SELECT * FROM app_info
        ORDER BY id DESC LIMIT 1;
        """
        /// 获取记录总数
        case recordAmount =
        """
        SELECT count(*) FROM app_info
        """
        /// 删除旧的记录
        case delegetOldRecord =
        """
        DELETE FROM app_info
        WHERE id < ?
        """
    }
}
