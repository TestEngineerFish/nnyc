//
//  YXStudyViewModelCtrl.m
//  YXEDU
//
//  Created by shiji on 2018/4/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyCmdCenter.h"
#import "YXUtils.h"
#import "YXConfigure.h"
#import "YXBookModel.h"
#import "YXStudyProgressModel.h"
#import "YXStudyViewModel.h"
#import "YXStudyRecordCenter.h"
#import "YXInterfaceCacheService.h"

#define groupPage 1

@interface YXStudyCmdCenter ()
@property (nonatomic, strong) YXStudyBookUnitModel *unitModel;
@property (nonatomic, strong) YXStudyBookUnitInfoModel *curUnitInfo;
@property (nonatomic, strong) YXStudyBookUnitTopicModel *curTopic;

@property (nonatomic, assign) NSInteger questionTotalIdx;
@property (nonatomic, assign) NSInteger wordIdx;
@property (nonatomic, assign) NSInteger unitIdx;
@property (nonatomic, assign) NSInteger groupIdx;

@end

@implementation YXStudyCmdCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)shared {
    static YXStudyCmdCenter *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXStudyCmdCenter new];
    });
    return shared;
}

- (void)currentUnitInfo:(id)model {
    self.unitModel = model;
    self.curUnitInfo = self.unitModel.unitinfo.firstObject;
    self.unitIdx = self.unitModel.unitid.integerValue;
    self.wordIdx = 0;
    self.groupIdx = 0;
    self.questionTotalIdx = 0;
}

- (void)setCurUnitInfo:(YXStudyBookUnitInfoModel *)curUnitInfo {
    _curUnitInfo = curUnitInfo;
}

// 输入答案
- (void)enterAnswer:(YXAnswerModel *)answer {
    NSString *right = @"0";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == %@", answer.type];
    YXStudyBookUnitTopicModel *topicModel = [self.curUnitInfo.topic filteredArrayUsingPredicate:predicate].firstObject;
    if ([answer.type isEqualToString:@"1"]) { // 选图
        if ([answer.answer isEqualToString:topicModel.answer]) { // 答对
            self.answerType = YXAnswerSelectImageRight;
            right = @"1";
            [YXUtils playRight];
        } else {
            if (self.answerType == YXAnswerSelectImageState) {
                self.answerType = YXAnswerSelectImageWrong1;
            } else if (self.answerType == YXAnswerSelectImageWrong1) {
                self.answerType = YXAnswerSelectImageWrong2;
            } else if (self.answerType == YXAnswerSelectImageWrong2) {
                self.answerType = YXAnswerSelectImageWrong3;
            }
            [YXUtils playWrong];
        }
    } else if ([answer.type isEqualToString:@"2"]) { // 英译汉
        if ([answer.answer isEqualToString:topicModel.answer]) {
            self.answerType = right;
            right = @"1";
            [YXUtils playRight];
        } else {
            if (self.answerType == start) {
                self.answerType = wrongOnce;
            } else if (self.answerType == wrongOnce) {
                self.answerType = wrongTwice;
            } else if (self.answerType == wrongTwice) {
                self.answerType = wrongThreeTime;
            }
            [YXUtils playWrong];
        }
    } else if ([answer.type isEqualToString:@"3"]) { // 汉译英
        if ([answer.answer isEqualToString:topicModel.answer]) {
            self.answerType = YXAnswerChineseTranslationEnglishRight;
            right = @"1";
            [YXUtils playRight];
        } else {
            if (self.answerType == YXAnswerChineseTranslationEnglishState) {
                self.answerType = YXAnswerChineseTranslationEnglishWrong1;
            } else if (self.answerType == YXAnswerChineseTranslationEnglishWrong1) {
                self.answerType = YXAnswerChineseTranslationEnglishWrong2;
            } else if (self.answerType == YXAnswerChineseTranslationEnglishWrong2) {
                self.answerType = YXAnswerChineseTranslationEnglishWrong3;
            }
            [YXUtils playWrong];
        }
    } else if ([answer.type isEqualToString:@"4"]) { // 拼写
        if ([answer.answer isEqualToString:self.curUnitInfo.word]) {
            self.answerType = YXAnswerWordSpellRight;
            right = @"1";
            [YXUtils playRight];
        } else {
            if (self.answerType == YXAnswerWordSpellState) {
                self.answerType = YXAnswerWordSpellWrong1;
            } else if (self.answerType == YXAnswerWordSpellWrong1) {
                self.answerType = YXAnswerWordSpellWrong2;
            } else if (self.answerType == YXAnswerWordSpellWrong2) {
                self.answerType = YXAnswerWordSpellWrong3;
            }
            [YXUtils playWrong];
        }
    }
    NSInteger q_idx = 0;
    YXStudyRecordModel *recordModel = [[YXStudyRecordModel alloc]init];
    for (YXUnitModel *unit in [YXConfigure shared].loginModel.learning.unit) {
        if ([unit.unitid isEqualToString:_unitModel.unitid]) {
            if ([right isEqualToString:@"1"]) {
                q_idx = unit.q_idx.integerValue;
                unit.q_idx = [NSString stringWithFormat:@"%ld", (long)(q_idx + 1)];
                if ([answer.type isEqualToString:@"4"]) { // 每次拼写
                    unit.learned = [NSString stringWithFormat:@"%ld", (long)(unit.learned.integerValue + 1)];
                }
                recordModel.learn_status = @"1";
            } else {
                q_idx = unit.q_idx.integerValue;
                recordModel.learn_status = @"0";
            }
            q_idx = q_idx + unit.learn_status.integerValue;
        }
    }
    recordModel.recordid = [YXStudyRecordCenter shared].recordId;
    recordModel.bookid = _unitModel.bookid;
    recordModel.unitid = _unitModel.unitid;
    recordModel.questionidx = [NSString stringWithFormat:@"%ld", (long)q_idx];
    recordModel.questionid = topicModel.question_id;
    recordModel.uuid = [YXConfigure shared].uuid;
    // book_id,unit_id,question_id,question_type, right,answer,learn_start,learning_finish
    recordModel.log = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@\n",
                       _unitModel.bookid,
                       _unitModel.unitid,
                       topicModel.question_id,
                       answer.type,
                       right,
                       answer.answer,
                       [YXStudyRecordCenter shared].startTime,
                       [YXUtils getCurTime]];
    [[YXStudyRecordCenter shared]insertRecord:recordModel completeBlock:^(id obj, BOOL result) {
    }];
    [[YXStudyRecordCenter shared] startTime];
    
    // 更新缓存数据
    [[YXInterfaceCacheService shared]updateLearning:[YXConfigure shared].loginModel.learning];
    
}


// 动作命令
- (void)studyAction:(YXActionType)actionType {
    if (actionType == YXActionSelectImageContinue) {
        if (self.answerType == YXAnswerSelectImageWrong3) {
            self.answerType = YXAnswerSelectImageWrong2;  // 恢复初始状态
        } else if (self.answerType == YXAnswerSelectImageRight) {
            // TODO::推送Action
            [self pushNextAction];
        } else if (self.answerType == wrongThreeTime) {
            self.answerType = wrongTwice; // 英译汉
        } else if (self.answerType == right) {
            // TODO::推送Action
            [self pushNextAction];
        } else if (self.answerType == YXAnswerChineseTranslationEnglishWrong3) {
            self.answerType = YXAnswerChineseTranslationEnglishWrong2; // 汉译英
        } else if (self.answerType == YXAnswerChineseTranslationEnglishRight) {
            // TODO::推送Action
            [self pushNextAction];
        } else if (self.answerType == YXAnswerWordSpellWrong3) {
            self.answerType = YXAnswerWordSpellWrong2; // 汉译英
        } else if (self.answerType == YXAnswerWordSpellRight) {
            // TODO::推送Action
            [self pushNextAction];
            
        } else if (self.answerType == YXAnswerNextGroup) {
            // TODO::推送下一个单词
            [self pushNextGroupWord];
        }  else if (self.answerType == YXAnswerNextUnit) {
            // TODO::推送下一个单元
        }
        
    }
}

// 解释命令
- (void)setAnswerType:(YXAnswerType)answerType {
    _answerType = answerType;
    switch (answerType) {
        case YXAnswerSelectImageState:
            self.showTipView(@(YXAnswerSelectImageState));
            break;
        case YXAnswerSelectImageWrong1:
            self.showTipView(@(YXAnswerSelectImageWrong1));
            break;
        case YXAnswerSelectImageWrong2:
            self.showTipView(@(YXAnswerSelectImageWrong2));
            break;
        case YXAnswerSelectImageWrong3:
            self.showTipView(@(YXAnswerSelectImageWrong3));
            break;
        case YXAnswerSelectImageRight:
            self.showTipView(@(YXAnswerSelectImageRight));
            break;
            
        case start:
            self.showTipView(@(start));
            break;
        case wrongOnce:
            self.showTipView(@(wrongOnce));
            break;
        case wrongTwice:
            self.showTipView(@(wrongTwice));
            break;
        case wrongThreeTime:
            self.showTipView(@(wrongThreeTime));
            break;
        case right:
            self.showTipView(@(right));
            break;
            
            
        case YXAnswerChineseTranslationEnglishState:
            self.showTipView(@(YXAnswerChineseTranslationEnglishState));
            break;
        case YXAnswerChineseTranslationEnglishWrong1:
            self.showTipView(@(YXAnswerChineseTranslationEnglishWrong1));
            break;
        case YXAnswerChineseTranslationEnglishWrong2:
            self.showTipView(@(YXAnswerChineseTranslationEnglishWrong2));
            break;
        case YXAnswerChineseTranslationEnglishWrong3:
            self.showTipView(@(YXAnswerChineseTranslationEnglishWrong3));
            break;
        case YXAnswerChineseTranslationEnglishRight:
            self.showTipView(@(YXAnswerChineseTranslationEnglishRight));
            break;
            
            
        case YXAnswerWordSpellState:
            self.showTipView(@(YXAnswerWordSpellState));
            break;
        case YXAnswerWordSpellWrong1:
            self.showTipView(@(YXAnswerWordSpellWrong1));
            break;
        case YXAnswerWordSpellWrong2:
            self.showTipView(@(YXAnswerWordSpellWrong2));
            break;
        case YXAnswerWordSpellWrong3:
            self.showTipView(@(YXAnswerWordSpellWrong3));
            break;
        case YXAnswerWordSpellRight:
            self.showTipView(@(YXAnswerWordSpellRight));
            break;
            
            // 下一组
        case YXAnswerNextGroup:
            [[YXStudyRecordCenter shared]createPackage:^(id obj, BOOL result) {}]; // 打包
            self.showTipView(@(YXAnswerNextGroup));
            break;
            
        case YXAnswerNextUnit:
            [[YXStudyRecordCenter shared]createPackage:^(id obj, BOOL result) {}]; // 打包
            self.showTipView(@(YXAnswerNextUnit));
            break;
        default:
            break;
    }
}



- (void)pushNextGroupWord {
    self.nextWord(self.curUnitInfo.topic[0]);
    self.wordIdx ++;
    // 上报数据
}

- (YXStudyBookUnitTopicModel *)curTopic {
    return self.curUnitInfo.topic[0];
}

- (void)pushNextAction {
    
    if (self.unitModel.unitinfo.count > self.wordIdx) { // 推送下一个单词
        self.curUnitInfo = _unitModel.unitinfo[self.wordIdx];
        self.questionTotalIdx ++;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %ld", (long)self.wordIdx-1];
        if ([_unitModel.group filteredArrayUsingPredicate:predicate].count) {
            self.nextGroup(_curUnitInfo.topic[0]);
            self.groupIdx ++;
        } else {
            self.nextWord(_curUnitInfo.topic[0]);
            self.wordIdx ++;
        }
    } else { // 推送下一个单元
        self.unitIdx ++;
        self.questionTotalIdx ++;
        self.nextUnit(_unitModel);
        self.wordIdx = 0;
        self.groupIdx = 0;
    }
    NSLog(@"groupIdx:%ld", (long)self.groupIdx);
    NSLog(@"wordIdx:%ld", (long)self.wordIdx);
}

// 开始学习
- (void)startTopic {
    self.curUnitInfo = self.unitModel.unitinfo.firstObject;
    self.wordIdx = 1; // 下次推送下一道题目
    self.groupIdx = 0;
    self.questionTotalIdx = 0;
    self.nextQuestion(_curUnitInfo.topic[0]);
    [[YXStudyRecordCenter shared]startRecord];
    [[YXStudyRecordCenter shared]createRecordId];
}

// 显示上一次学习的位置
- (void)lastStudyPosition {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.unitid == %@", _unitModel.unitid];
    YXUnitModel *unit = [[YXConfigure shared].loginModel.learning.unit filteredArrayUsingPredicate:predicate].firstObject;
    
    NSInteger q_Index = unit.q_idx.integerValue + unit.learn_status.integerValue;
    self.curUnitInfo = self.unitModel.unitinfo[q_Index];
    self.groupIdx = 0;
    
    [_unitModel.group enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger groupindex = ((NSString *)obj).intValue;
        if (groupindex <= q_Index) {
            self.groupIdx++;
        } else {
            *stop = YES;
        }
    }];
    self.questionTotalIdx = q_Index + _groupIdx - 1;
    self.nextQuestion(_curUnitInfo.topic[0]);
}

// 从已经学习的位置继续学习
- (void)startContinue {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.unitid == %@", _unitModel.unitid];
    YXUnitModel *unit = [[YXConfigure shared].loginModel.learning.unit filteredArrayUsingPredicate:predicate].firstObject;
    
    NSInteger q_Index = unit.q_idx.integerValue + unit.learn_status.integerValue;
    self.curUnitInfo = self.unitModel.unitinfo[q_Index];
    self.groupIdx = 0;
    self.wordIdx = q_Index + 1; // 下次推送下一道题目
    [_unitModel.group enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger groupindex = ((NSString *)obj).intValue;
        if (groupindex < q_Index) {
            self.groupIdx++;
        } else {
            *stop = YES;
        }
    }];
    self.questionTotalIdx = q_Index; // question number and group page number
    self.nextQuestion(_curUnitInfo.topic[0]); // 重新刷新页面
    [[YXStudyRecordCenter shared]startRecord];
    [[YXStudyRecordCenter shared]createRecordId];
}

// 单前组的index
- (NSInteger)groupIndex {
    return self.groupIdx;
}

// 单前组的单词数
- (NSString *)groupWordCount {
    NSNumber *groupWordCount = self.unitModel.group_word_count[self.groupIdx];
    return [NSString stringWithFormat:@"%ld", (long)groupWordCount.integerValue];
}

// 本单元的单词总数
- (NSString *)unitWordCount {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.unitid == %@", _unitModel.unitid];
    
    YXUnitModel *unit = [[YXConfigure shared].loginModel.learning.unit filteredArrayUsingPredicate:predicate].firstObject;
    return unit.word;
}

// 组数
- (NSInteger)groupNum {
    return self.unitModel.group_word_count.count;
}

- (NSInteger)groupQuestionLearnCount {
    NSInteger wordTotal = 0;
    if (_groupIdx > 0) {
        wordTotal += ((NSString *)self.unitModel.group[_groupIdx-1]).intValue + 1;
    }
    NSLog(@"-------%ld", (long)self.questionTotalIdx);
    NSLog(@"-------%ld", (long)(self.questionTotalIdx - wordTotal));
    return self.questionTotalIdx - wordTotal;
}

// 每组的问题数目
- (NSInteger)groupQuestionCount {
    if (self.unitModel.group.count > 0) {
        if (self.unitModel.group.count > self.groupIdx) {
            if (self.groupIdx == 0) {
                return ((NSString *)self.unitModel.group[self.groupIdx]).integerValue + 1;
            } else {
                return ((NSString *)self.unitModel.group[self.groupIdx]).integerValue - ((NSString *)self.unitModel.group[self.groupIdx-1]).integerValue;
            }
        }
        return self.unitModel.unitinfo.count - ((NSString *)self.unitModel.group.lastObject).integerValue-1;
    }
    return self.unitModel.unitinfo.count;
}

// 单前单元数
- (NSInteger)unitIndex {
    __block NSInteger unitIdx = 0;
    [[YXConfigure shared].loginModel.learning.unit enumerateObjectsUsingBlock:^(YXUnitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unitIdx = idx + 1;
        if ([obj.unitid isEqualToString:self.unitModel.unitid]) {
            *stop = YES;
        }
    }];
    return unitIdx;
}

@end
