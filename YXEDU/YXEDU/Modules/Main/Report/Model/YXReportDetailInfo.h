//
//  YXReportDetailInfo.h
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXIndexModel.h"
//answerNum = 720;
//clock = 267;
//correctRatio = 1;
//learnDays = 65;
//learnTime = "37.18";
//learned = 2251;


//userInfo =     {
//    avatar = "";
//    nick = "\U7528\U6237189****0015";
//};


//efficiency = "0.95";
//habit = "0.7";
//memory = "0.2";
//stability = "0.95";
//will = "0.2";

@interface YXReportUserInfo : NSObject
/** 头像 */
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *nick;
@end

@interface YXBaseReportData : NSObject
@property (nonatomic, copy)NSString *answerNum;
/** 用户打卡次数 */
@property (nonatomic, copy)NSString *clock;
/** 用户学习的正答率 */
@property (nonatomic, copy)NSString *correctRatio;
@property (nonatomic, copy)NSString *learnDays;
@property (nonatomic, copy)NSString *learnTime;
@property (nonatomic, copy)NSString *learned;
@property (nonatomic, copy)NSString *learnSpeed;
@end

@interface YXNationReportData : YXBaseReportData

@end


@interface YXMyAbility : NSObject
/** 效率 */
@property (nonatomic, assign)CGFloat efficiency;
@property (nonatomic, assign)CGFloat habit;
@property (nonatomic, assign)CGFloat memory;
@property (nonatomic, assign)CGFloat stability;
@property (nonatomic, assign)CGFloat will;
@end

@interface YXOverallModel : NSObject
@property (nonatomic, copy)NSArray *options;
@property (nonatomic, copy)NSString *revel;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger type;
@end

@interface YXMyReportData : YXBaseReportData
@property (nonatomic, strong)YXMyAbility *ability;
@property (nonatomic, strong)NSMutableArray *learnIndex;
@property (nonatomic, strong)NSMutableArray *overall;
@end

@interface YXReportDetailInfo : NSObject
@property (nonatomic, strong)YXReportUserInfo *userInfo;
@property (nonatomic, strong)YXBaseReportData *firstReport;
@property (nonatomic, strong)YXNationReportData *nationReport;
@property (nonatomic, strong)YXMyReportData *userReport;

@property (nonatomic, copy)NSArray *learnedQues;
@property (nonatomic, copy)NSArray *answersQues;
@property (nonatomic, copy)NSArray *correctPercents;
@property (nonatomic, copy)NSArray *learnedDays;
- (void)dataSetup;
@end

