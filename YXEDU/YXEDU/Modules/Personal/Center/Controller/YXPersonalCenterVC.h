//
//  YXPersonlCenterVC.h
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXNOSignalVC.h"

static NSString *const kRemindDatekey = @"RemindDatekey";
static NSString *const kPersonalCenterRightDetailKey = @"PersonalCenterRightDetailKey";

@interface YXPersonalCenterVC : YXNOSignalVC

@property (nonatomic, strong) NSArray *allBadgesDetails;

@end
