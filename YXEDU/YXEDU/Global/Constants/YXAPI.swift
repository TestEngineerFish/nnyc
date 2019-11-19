//
//  YXAPI.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXAPI {
    
    //MARK: - 用户模块
    struct User {
        
    }
    
    //MARK: - 个人模块
    struct Profile {
        
    }
    
    //MARK: - 单词模块
    struct Word {
        /// 练习接口
        static let exercise = "/api/v1/learn/exercise"
        /// 学习地图
        static let learnMap = "/api/v1/learn/getbookunitstatus"
        /// 学习结果页
        static let learnResult = "/api/v1/learn/getcurrentunitstatus"
        /// 学习结果页
        static let report = "/api/v1/result"
        /// 用户添加词书
        static let addUserBook = "/api/v1/book/adduserbook"
    }

    
    //MARK: - 设置模块
    struct Setting {
        
    }
}

