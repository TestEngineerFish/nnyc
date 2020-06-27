//
//  YXDatabaseConfig+OptionConfig.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    enum OptionConfigSQL: String {
        case insert =
        """
        INSERT INTO step_config_table_v1
        (wordId, step, black_list)
        VALUES (?, ?, ?)
        """

        case seleteBlackList =
        """
        SELECT * FROM step_config_table_v1
        WHERE step = ? and wordId = ?
        """

        case deleteAll =
        """
        delete from step_config_table_v1
        """
    }
}
