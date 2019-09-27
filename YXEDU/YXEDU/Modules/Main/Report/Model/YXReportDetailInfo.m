//
//  YXReportDetailInfo.m
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportDetailInfo.h"

@implementation YXReportUserInfo

@end

@implementation YXBaseReportData

@end

@implementation YXNationReportData
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"answerNum"      : @"aAnswerNum" ,
             @"clock"          : @"aClock",
             @"correctRatio"   : @"aCorrectRatio",
             @"learnDays"      : @"aLearnDays",
             @"learnTime"      : @"aLearnTime",
             @"learned"        : @"aLearned",
             @"learnSpeed"     : @"aLearnSpeed"
             };
}
@end

@implementation YXMyAbility

@end

@implementation YXMyReportData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"learnIndex" : [YXIndexModel class],
             @"overall"    : [YXOverallModel class]
             };
}
@end

@implementation YXOverallModel

@end


@implementation YXReportDetailInfo

-(void)dataSetup {
//    self.learnedQues = @[
//                         _userReport.learned,
//                         _nationReport.learned,
//                         _firstReport.learned
//                         ];
    
    self.answersQues = @[
                         _userReport.answerNum,
                         _nationReport.answerNum,
                         _firstReport.answerNum];
    
    self.correctPercents = @[
                             _userReport.correctRatio,
                             _nationReport.correctRatio,
                             _firstReport.correctRatio
                             ];
    
    self.learnedDays = @[
                         _userReport.learnDays,
                         _nationReport.learnDays,
                         _firstReport.learnDays
                         ];
}
@end


