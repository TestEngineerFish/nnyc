//
//  YXReporAreaView.h
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLearnReportModel.h"
@interface YXReporAreaView : UIView
@property (nonatomic, copy)void(^checkReportBlock)(NSInteger index);
@property (nonatomic, assign)BOOL hasReport;
@property (nonatomic, strong)YXLearnReportModel *reportModel;
 @property (nonatomic, copy) NSString *taskStatusString;
@property (nonatomic, assign) BOOL isTodayCheckin;
@end
