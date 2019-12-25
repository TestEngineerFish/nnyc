//
//  YXAPI.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXAPI {
    //MARK: - 登陸註冊
    struct RegisterAndLogin {
        // 登陸
        static let login = "/v1/user/reg"
        
        // 發送短信
        static let sendSms = "/api/v1/user/sendsms"
    }
    
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
    
    //MARK: - 练习模块
    struct Exercise {
        /// 练习接口
        static let exercise = "/api/v1/learn/getsteps"
        /// 学习地图
        static let learnMap = "/api/v1/learn/getbookunitstatus"
        /// 学习结果页
        static let learnResult = "/api/v1/learn/getcurrentunitstatus"
        /// 上报接口
        static let report = "/api/v1/result"
    }
    
    
    //MARK: - 单词模块
    struct Word {
        // 户添加词书
        static let downloadWordBook = "/api/v1/book/getstudybooklist"
        
        /// 用户添加词书
        static let addUserBook = "/api/v1/book/adduserbook"
        /// 搜索单词
        static let searchWord = "/api/v1/search"
    }

    // MARK: - 复习模块
    struct Review {
        /// 获得复习计划中词书选项列表
        static let reviewBookList = "/api/v1/learn/getreviewbooklist"
        /// 获得复习计划中词书选项中单词列表
        static let reviewWordList = "/api/v1/learn/getreviewwordlist"
        /// 创建复习计划
        static let maekReviewPlan = "/api/v1/learn/createreviewplan"
        /// 获得复习计划列表
        static let reviewPlan = "/api/v1/learn/getreviewplanlist"
        /// 获得复习计划详情
        static let reviewPlanDetail = "/api/v1/learn/getreviewplaninfo"
        /// 口令查询
        static let checkCommand = "/api/v1/learn/getsharereviewplan"        
        /// 复习结果页
        static let reviewResult = "/api/v1/learn/result"
    }

    // MARK: - 单词列表模块
    struct WordList {
        // 收藏、已学、未学列表
        static let wordList = "/api/v1/word/getnotelist"
        
        // 错词
        static let wrongWordList = "/api/v1/word/getwronglist"
        
        // 收藏
        static let collectWord = "/api/v1/word/favorite"

        // 取消收藏
        static let cancleCollectWord = "/api/v1/word/unfavorite"
        
        // 刪除錯詞
        static let deleteWrongWord = "/api/v1/word/delwrong"
        
        // 是否收藏單詞
        static let didCollectWord = "/api/v1/word/isfavorite"
    }
    
    // MARK: - 单词列表模块
    struct TaskCenter {
        // 打卡
        static let punchIn = "/api/v1/user/signin"
        
        // 日期數據
        static let punchData = "/api/v1/user/signininfo"
        
        // 任務卡片
        static let taskList = "/api/v1/user/task"
        
        // 領取積分
        static let getIntegral = "/api/v1/user/receivetaskreward"
    }

    // MARK: - 挑战模块
    struct Challenge {
        /// 挑战页面接口
        static let challengeModel = "/api/v1/game/info"
        /// 开始游戏接口
        static let playGame       = "/api/v1/game/starting"
        /// 游戏结果上报接口
        static let gameReport     = "/api/v1/game/stopping"
        /// 挑战排名接口
        static let rankedList     = "/api/v1/game/ranking"
        /// 解锁挑战
        static let unlock         = "/api/v1/game/undo"
    }
    
    //MARK: - 设置模块
    struct Setting {
        /// 检查版本接口
        static let checkVersion = "/api/v1/check-version"

    }
}

