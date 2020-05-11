//
//  YXExerciseType.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 单词练习类型
enum YXExerciseType: String {
    //MARK: ---- 选择题
    case lookWordChooseImage = "Q-A-1"                    // 看单词选图片
    case lookExampleChooseImage = "Q-A-2"                 // 看例句选图片
    case lookWordChooseChinese = "Q-A-3"                  // 看单词选中文
    case lookExampleChooseChinese = "Q-A-4"               // 看例句选中文
    case lookChineseChooseWord = "Q-A-5"                  // 看中文选单词
    case lookImageChooseWord = "Q-A-6"                    // 看图片选单词
    
    //MARK: ---- 判断题
    case validationWordAndChinese = "Q-A-7"               // 判断单词和词义对错
    case validationImageAndWord = "Q-A-8"                 // 判断图片和单词对错
    
    //MARK: ---- 听力题
    case listenChooseWord = "Q-C-1"                       // 听录音选单词
    case listenChooseChinese = "Q-C-2"                    // 听录音选词义
    case listenChooseImage = "Q-C-3"                      // 听录音选图片
    
    case listenFillWord = "Q-C-9"                         // 听录音输入单词
    
    //MARK: ---- 连线题
    case connectionWordAndChinese = "Q-A-9"               // 连接单词和中文
    case connectionWordAndImage = "Q-A-10"                 // 连接单词和图片
    
    //MARK: ---- 填空题
    case fillWordAccordingToChinese = "Q-B-1"             // 看中文填空（附加中文，仅点击）
    case fillWordAccordingToListen = "Q-B-2"              // 听录音填空（附加听录音，仅点击）
    case fillWordAccordingToImage = "Q-B-3"               // 看图片填空（附加图片，仅点击）
    
    case fillWordAccordingToChinese_Connection = "Q-B-4"  // 看中文填空（点击or连线）
    case fillWordGroup = "Q-B-5"                          // 词组填空（词组）

    //MARK: ---- 新学流程
    case newLearnPrimarySchool = "N-1"                    // 小学新学
    case newLearnPrimarySchool_Group = "N-1-1"            // 小学新学(词组)
    case newLearnJuniorHighSchool = "N-2"                 // 初中新学
    
    case none = ""
}


enum YXExerciseRuleType: String {
    case p = "p"        // 原始规则
    case p1 = "p1"      // 跳过新学
    case p2 = "p2"      // 跳过新学，做题时首次做新学词题目后无论对错必定出现单词详情
    case p3 = "p3"      // 新学为看所有单词列表
    case p4 = "p4"      // 分步新学每组新学5个，复习5个每组开始学习时，先走新学流程
    case a1 = "a1"      // 分步新学每组开始学习时，先走新学流程每组新学3个，复习4个新学流程【不能打断】
    case a2 = "a2"      // 分步新学每组开始学习时，先走新学流程每组新学3个，复习4个新学流程【可以打断】
}
