//
//  YXStudyViewModelCtrl.h
//  YXEDU
//
//  Created by shiji on 2018/4/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXAnswerModel.h"
#import "YXStudyBookUnitModel.h"

#define duration 0.3

typedef NS_ENUM(NSInteger, YXActionType) {
    YXActionSelectImageContinue,     // 选择图片继续按钮
    YXActionSelectUnitGroup,         // 组和单元选取
};

typedef NS_ENUM(NSInteger, YXAnswerType) {
    YXAnswerSelectImageState,  // 图片选择状态
    YXAnswerSelectImageWrong1,  // 图片选择错误1
    YXAnswerSelectImageWrong2,  // 图片选择错误2
    YXAnswerSelectImageWrong3,  // 图片选择错误3
    YXAnswerSelectImageRight,   // 图片选择正确
    
    YXAnswerEnglishTranslationChineseState, // 英译汉状态
    YXAnswerEnglishTranslationChineseWrong1,  // 英译汉错误1
    YXAnswerEnglishTranslationChineseWrong2,  // 英译汉错误2
    YXAnswerEnglishTranslationChineseWrong3,  // 英译汉错误3
    YXAnswerEnglishTranslationChineseRight,  // 英译汉正确
    
    
    YXAnswerChineseTranslationEnglishState, // 汉译英状态
    YXAnswerChineseTranslationEnglishWrong1,  // 汉译英错误1
    YXAnswerChineseTranslationEnglishWrong2,  // 汉译英错误2
    YXAnswerChineseTranslationEnglishWrong3,  // 汉译英错误3
    YXAnswerChineseTranslationEnglishRight,  // 汉译英正确
    
    
    YXAnswerWordSpellState,  // 单词拼写状态
    YXAnswerWordSpellWrong1,  // 单词拼写错误1
    YXAnswerWordSpellWrong2,  // 单词拼写错误2
    YXAnswerWordSpellWrong3,  // 单词拼写错误3
    YXAnswerWordSpellRight,  // 单词拼写正确
    
    YXAnswerNextGroup,       // 下一组
    YXAnswerNextUnit,        // 下一单元
};

typedef void(^PushNextQuestion)(id obj);
typedef void(^PushNextWord)(id obj);
typedef void(^PushNextUnit)(id obj);
typedef void(^PushNextGroup)(id obj);

typedef void (^ShowTipView)(id obj);

@interface YXStudyCmdCenter : NSObject
@property (nonatomic, copy) PushNextQuestion nextQuestion;
@property (nonatomic, copy) PushNextWord nextWord;
@property (nonatomic, copy) PushNextUnit nextUnit;
@property (nonatomic, copy) PushNextGroup nextGroup;
@property (nonatomic, copy) ShowTipView showTipView;
@property (nonatomic, assign) YXAnswerType answerType;
@property (nonatomic, strong, readonly) YXStudyBookUnitInfoModel *curUnitInfo;
@property (nonatomic, strong, readonly) YXStudyBookUnitTopicModel *curTopic;
+ (instancetype)shared;

- (void)currentUnitInfo:(id)model;

- (YXStudyBookUnitTopicModel *)curTopic;

- (void)studyAction:(YXActionType)actionType;
- (void)enterAnswer:(YXAnswerModel *)answer;

// 进入该单元第一次调用
- (void)startTopic;

// 显示上一次学习的位置
- (void)lastStudyPosition;

// 从已经学习的位置继续学习
- (void)startContinue;

// 返回单前组的index
- (NSInteger)groupIndex;

// 返回单前组的单词个数
- (NSString *)groupWordCount;

// 本单元的单词总数
- (NSString *)unitWordCount;

// 组数
- (NSInteger)groupNum;

// 已经学习的单词数
- (NSInteger)groupQuestionLearnCount;

// 每组的问题数目
- (NSInteger)groupQuestionCount;

// 单前单元数
- (NSInteger)unitIndex;
@end
