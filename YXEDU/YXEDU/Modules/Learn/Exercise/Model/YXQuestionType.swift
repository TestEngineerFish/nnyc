//
//  YXExerciseType.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 单词练习类型
enum YXQuestionType: String {

    //MARK: ---- 新学流程
    case newLearnPrimarySchool_Group = "T-N-0" // 小学新学(词组)
    case newLearnPrimarySchool       = "T-N-1" // 小学新学
    case newLearnJuniorHighSchool    = "T-N-2" // 初中新学
    case newLearnMasterList          = "T-N-3" // 掌握列表

    //MARK: ---- 选择题
    case lookWordChooseImage      = "Q-A-1" // 看单词选图片
    case lookExampleChooseImage   = "Q-A-2" // 看例句选图片
    case lookWordChooseChinese    = "Q-A-3" // 看单词选中文
    case lookExampleChooseChinese = "Q-A-4" // 看例句选中文
    case lookChineseChooseWord    = "Q-A-5" // 看中文选单词
    case lookImageChooseWord      = "Q-A-6" // 看图片选单词
    
    //MARK: ---- 判断题
    case validationWordAndChinese = "Q-A-7" // 判断单词和词义对错
    case validationImageAndWord   = "Q-A-8" // 判断图片和单词对错

    //MARK: ---- 填空题
    case fillWordAccordingToChinese            = "Q-B-1" // 看中文填空（附加中文，仅点击）
    case fillWordAccordingToListen             = "Q-B-2" // 听录音填空（附加听录音，仅点击）
    case fillWordAccordingToImage              = "Q-B-3" // 看图片填空（附加图片，仅点击）
    case fillWordAccordingToChinese_Connection = "Q-B-4" // 看中文填空（点击or连线）
    case fillWordGroup                         = "Q-B-5" // 词组填空（词组）

    //MARK: ---- 听力题
    case listenChooseWord    = "Q-C-1" // 听录音选单词
    case listenChooseChinese = "Q-C-2" // 听录音选词义
    case listenChooseImage   = "Q-C-3" // 听录音选图片
    case listenFillWord      = "Q-C-9" // 听录音输入单词

    //MARK: ---- 全拼题
    case allFillWordByAtLookChinese = "Q-B-1-H" // 看词义全拼单词
    case allFillAtListen            = "Q-B-2-H" //听读音全拼单词
    
    case none = ""
}

@objc enum YXLearnType: Int {
    case base             = 1  // 基础学习
    case wrong            = 2  // 抽查
    case planListenReview = 3  // 计划——听力复习
    case planReview       = 4  // 计划——复习
    case aiReview         = 5  // 智能复习
    case homeworkWord     = 8  // 课外作业,单词练习
    case homeworkListen   = 9  // 课外作业,听写练习
    case homeworkPunch    = 10 // 课外作业,打卡练习
    case challengeGame    = 11 // 挑战游戏
    var desc: String {
        var value = ""
        switch self {
        case .base:
            value = "主流程学习"
        case .wrong:
            value = "错题本抽查"
        case .planListenReview:
            value = "词单听力"
        case .planReview:
            value = "词单复习"
        case .aiReview:
            value = "智能复习"
        case .homeworkPunch:
            value = "打卡作业"
        case .homeworkListen:
            value = "听写作业"
        case .homeworkWord:
            value = "单词作业"
        case .challengeGame:
            value = "挑战游戏"
        default:
            value = "默认主流程学习"
        }
        return value + "\(self.rawValue)"
    }
    
    func isHomework() -> Bool {
        if self == .homeworkWord || self == .homeworkPunch || self == .homeworkListen {
            return true
        } else {
            return false
        }
    }
}
