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
        static let learnMap = "api/v1/learn/getbookunitstatus"
    }

    
    //MARK: - 设置模块
    struct Setting {
        
    }
}

