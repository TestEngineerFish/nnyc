//
//  YXExerciseType.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 单词练习类型
enum YXExerciseType: Int {
    //MARK: ---- 选择题
    case lookWordChooseImage = 10                    // 看单词选图片
    case lookExampleChooseImage = 11                 // 看例句选图片
    case lookWordChooseChinese = 12                  // 看单词选中文
    case lookExampleChooseChinese = 13               // 看例句选中文
    case lookChineseChooseWord = 14                  // 看中文选单词
    case lookImageChooseWord = 15                    // 看图片选单词
    
    //MARK: ---- 判断题
    case validationWordAndChinese = 20               // 判断单词和词义对错
    case validationImageAndWord = 21                 // 判断图片和单词对错
    
    //MARK: ---- 听力题
    case listenChooseWord = 30                       // 听录音选单词
    case listenChooseChinese = 31                    // 听录音选词义
    case listenChooseImage = 32                      // 听录音选图片
    
    //MARK: ---- 连线题
    case connectionWordAndChinese = 40               // 连接单词和中文
    case connectionWordAndImage = 41                 // 连接单词和图片
    
    //MARK: ---- 填空题
    case fillWordAccordingToChinese = 50             // 看中文填空（附加中文，仅点击）
    case fillWordAccordingToListen = 51              // 听录音填空（附加听录音，仅点击）
    case fillWordAccordingToImage = 52               // 看图片填空（附加图片，仅点击）
    
    case fillWordAccordingToChinese_Connection = 53  // 看中文填空（点击or连线）
    case fillWordGroup = 54                          // 词组填空（词组）

    //MARK: ---- 新学流程
    case newLearnPrimarySchool = 60                  // 小学新学
    case newLearnPrimarySchool_Group = 61            // 小学新学(词组)
    case newLearnJuniorHighSchool = 62               // 初中新学
    
    case none = 0
}





///// 练习的问题类型
//enum YXExerciseQuestionType: Int {
//    //MARK: ---- 选择题，题型
//    case word                               // 单词+音标
//    case example                            // 例句
//    case chinese                            // 中文词义
//    case image                              // 图片
//    case wordAndChinese                     // 单词+音标+词义
//    case wordAndImage                       // 图片+单词+音标
//
//    //MARK: ---- 听力题，题型
//    case listenAndImage                     // 听录音+图片
//    case listenAndWord                      // 听录音+中文
//
//    //MARK: ---- 连线题，题型
//    case connectWordAndChinese              // 词义连线
//    case connectWordAndImage                // 词图连线
//
//    //MARK: ---- 填空题，题型
//    case fillByWordAndChinese               // 单词+词义
//    case fillByWordAndListen                // 单词+语音
//    case fillByWordAndImage                 // 单词+图片
//    case fillByChinse                       // 词义
//    case fillByWord                         // 词组
//
//    case none
//}
//
//
///// 练习的答案类型
//enum YXExerciseAnswerType: Int {
//    case image                              // 图片选项
//    case chinese                            // 中文词义选项
//    case word                               // 单词
//    case rightOrWrong                       // 对错
//    case wordMultiLine                      // 单词（多行）
//
//    case none
//}



//struct YXExerciseItem {
//    var questionType: YXExerciseQuestionType = .none
//    var answerType: YXExerciseAnswerType = .none
//}

