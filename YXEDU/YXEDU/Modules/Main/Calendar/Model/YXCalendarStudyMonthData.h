//
//  YXCalendarStudyMonthData.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXStudyMonthSummaryModel : NSObject
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, assign) NSInteger studyDays;
@property (nonatomic, assign) NSInteger studyWords;
@property (nonatomic, assign) NSInteger studyTimes;
@end

@interface YXNodeModel : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSNumber *num;
@property (nonatomic, assign) NSNumber *costTime;
@property (nonatomic, assign) NSNumber *status;
@end

@interface YXCalendarStudyMonthData : NSObject
@property (nonatomic, strong) NSString *userReg;
@property (nonatomic, strong) YXStudyMonthSummaryModel *summary;
@property (nonatomic, strong) NSMutableArray<YXNodeModel *> *studyDetail;
@property (nonatomic, strong) NSDictionary<NSString *, UIImage *> *punchedDateDict;//显示已打卡状态
@property (nonatomic, strong) NSDictionary<NSString *, UIColor *> *studiedDateDict;//显示已学习状态

@end

NS_ASSUME_NONNULL_END
