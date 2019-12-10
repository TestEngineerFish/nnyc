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
        // 用户配置信息
        static let userInformation = "/api/v1/user/config"
        
        // 徽章信息
        static let badgeList = "/api/v1/user/getbadgelist"
    }
    
    //MARK: - 单词模块
    struct Word {
        /// 练习接口
        static let exercise = "/api/v1/learn/exercise"
        /// 学习地图
        static let learnMap = "/api/v1/learn/getbookunitstatus"
        /// 学习结果页
        static let learnResult = "/api/v1/learn/getcurrentunitstatus"
        /// 上报接口
        static let report = "/api/v1/result"
        /// 用户添加词书
        static let addUserBook = "/api/v1/book/adduserbook"
    }

    // MARK: - 复习模块
    struct Review {
        /// 获得复习计划中词书选项列表
        static let reviewBookList = "/api/v1/learn/getreviewbooklist"
    }

    //MARK: - 单词列表模块
    struct WordList {
        // 收藏、已学、未学列表
        static let wordList = "api/v1/word/getnotelist"
        
        // 错词
        static let wrongWordList = "api/v1/word/getwronglist"
    }
    
    //MARK: - 设置模块
    struct Setting {
        
    }
}

