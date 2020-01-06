//
//  YXPersonalProfileVC.h
//  YXEDU
//
//  Created by shiji on 2018/9/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"

typedef void(^ReturnRemindDateStringBlock) (NSString *reminderDateString);

@interface YXPersonalReminderVC : BSRootVC

@property(nonatomic, strong) ReturnRemindDateStringBlock returnRemindDateStringBlock;
@property(nonatomic, strong) NSDate *remindDate;

@end
