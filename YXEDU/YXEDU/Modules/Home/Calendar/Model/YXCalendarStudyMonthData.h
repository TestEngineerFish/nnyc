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
@property (nonatomic, assign) NSInteger study_days;
@property (nonatomic, assign) NSInteger study_words;
@property (nonatomic, assign) NSInteger study_duration;
@end

@interface YXNodeModel : NSObject
@property (nonatomic, assign) NSNumber *date;
@property (nonatomic, assign) NSNumber *status;
@property (nonatomic, assign) NSNumber *num;
@property (nonatomic, assign) NSNumber *cost_time;
@end

@interface YXCalendarStudyMonthData : NSObject
@property (nonatomic, strong) YXStudyMonthSummaryModel *summary;
@property (nonatomic, strong) NSMutableArray<YXNodeModel *> *study_detail;
@property (nonatomic, strong) NSDictionary<NSString *, UIImage *> *punchedDateDict;//显示已打卡状态
@property (nonatomic, strong) NSDictionary<NSString *, UIColor *> *studiedDateDict;//显示已学习状态

@end

NS_ASSUME_NONNULL_END
