//
//  YXLoginModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXLoginSendModel.h"

@interface YXLoginViewModel : NSObject
// 登录
- (void)login:(YXLoginSendModel *)sendModel finished:(finishBlock)block;

// 请求用户信息
- (void)requestUserInfo:(finishBlock)block;

// 上报设备信息
- (void)reportDeviceStatistics:(finishBlock)block;
@end
