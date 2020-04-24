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
        
        // 退出
        static let logout = "/api/v1/user/logout"
        
        // 發送短信
        static let sendSms = "/api/v1/user/sendsms"
    }
    
    //MARK: - 主页
    struct Home {
        static let report = "/api/v1/user/learnreport"
        static let task   = "/api/v1/user/task/available"
        
        static let setReminder = "api/v1/user/setting"
    }
    
    //MARK: - 用户模块
    struct User {
        // 更新 TOKEN
        static let updateToken = "/api/v1/user/gettoken"
    }
    
    //MARK: - 个人模块
    struct Profile {
        // 用户配置信息
        static let userInformation = "/api/v1/user/config"
        
        // 徽章信息
        static let badgeList = "/api/v1/user/getbadgelist"
                
        /// 最新徽章
        static let latestBadge = "/api/v1/user/badge/new"
        
        /// 徽章展示上报接口
        static let badgeDisplayReport = "/api/v1/user/badge/report"
        
    }
    
    //MARK: - 练习模块
    struct Exercise {
        /// 练习接口
        static let exercise = "/api/v1/learn/getsteps"
        /// 学习地图
        static let learnMap = "/api/v1/learn/getbookunitstatus"
        /// 基础学习结果页
        static let learnResult = "/api/v2/learn/getcurrentunitstatus"
        /// 上报接口
        static let report = "/api/v1/learn/report"
        /// 单词跟读分上报
        static let reportListenScore = "/api/v1/learn/updatelistenscore"
    }
    
    
    //MARK: - 单词模块
    struct Word {
        // 下載词书
        static let downloadWordBook = "/api/v1/book/getstudybooklist"
        // 下載词书
        static let wordDetail       = "/api/v1/word/info"
        /// 用户添加词书
        static let addUserBook      = "/api/v1/book/adduserbook"
        /// 搜索单词
        static let searchWord       = "/api/v1/search"
        /// 获得词书中所有单词
        static let getBookWords     = "/api/v1/book/getbookwords"
        // 所以词书
        static let bookList = "/api/v1/book/getbooklist"
    }

    // MARK: - 复习模块
    struct Review {
        /// 获得复习计划中词书选项列表
        static let reviewBookList = "/api/v1/learn/getreviewbooklist"
        /// 获得复习计划中词书选项中单词列表
        static let reviewWordList = "/api/v1/learn/getreviewwordlist"
        /// 创建复习计划
        static let maekReviewPlan = "/api/v1/learn/createreviewplan"
        /// 修改复习计划名称
        static let updateReviewPlan = "/api/v1/learn/updatereviewplan"
        /// 删除复习计划
        static let removeReviewPlan = "/api/v1/learn/delreviewplan"
        /// 获得复习计划列表
        static let reviewPlan = "/api/v1/learn/getreviewplanlist"
        /// 获得复习计划详情
        static let reviewPlanDetail = "/api/v1/learn/getreviewplaninfo"
        /// 口令查询
        static let checkCommand = "/api/v1/learn/getsharereviewplan"
        /// 获取分享口令
        static let shareCommand = "/api/v1/learn/setsharereviewplan"
        /// 复习结果页
        static let reviewResult = "/api/v1/learn/result"
        /// 词单学习情况列表
        static let reviewPlanStatusList = "api/v1/learn/getsharestudylist"
        /// 获得词单学习情况列表
        static let studentStudyList = "/api/v1/learn/getsharestudylist"
        /// 获得词书单元列表
        static let unitList = "/api/v1/book/getbookunitlist"
        /// 错词本分页接口
        static let wordListWithWrong = "/api/v2/word/getwronglist"
        /// 获得复习计划单词列表
        static let wordListWithReviewPlan = "/api/v2/review/getreviewplanwordlist"
        static let resetReviewPlan = "/api/v1/learn/reviewplanereset"
    }

    // MARK: - 单词列表模块
    struct WordList {
        // 收藏、已学、未学列表
        static let wordList = "/api/v2/word/getnotelist"
        
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
    
    // MARK: - 学习日报模块
    struct StudyReport {
        // 学习日报
        static let studyReport = "api/v1/daily/info"
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
        /// 上期挑战是否向用户展示过接口
        static let showPrevious   = "/api/v1/game/pre/show"
    }

    // MARK: - 分享
    struct Share {
        static let punch = "/api/v1/user/punch/clock"
        
        static let changeBackgroundImage = "api/v1/learn/changebackground"
    }
    
    //MARK: - 设置模块
    struct Setting {
        /// 检查版本接口
        static let checkVersion = "/api/v1/checkversion"
        
        /// 老用户更新版本后的提示，上报接口
        static let oldUserReport = "api/v1/user/setting"
        

    }

    // MARK: - 其他
    struct Other {
        /// 日志数据上报
        static let report = "/api/v1/device/report"
        /// 用户反馈回复已读接口
        static let feedbackReport = "/api/v1/feedback/reply/report"
    }
    
    // MARK: - Badge
    struct Badge {
        /// 用户反馈回复接口
        static let feedbackReply = "/api/v1/feedback/reply"
    }

    // MARK: - Calendar
    struct Calendar {

        /// 获得月报学习时间列表
        static let getMonthly = "/api/v1/daily/getmonthly"
    }
}

