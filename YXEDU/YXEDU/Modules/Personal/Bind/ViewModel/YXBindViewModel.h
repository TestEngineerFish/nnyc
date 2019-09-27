//
//  YXBindViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBindModel.h"
#import "YXAPI.h"
#import "YXSendSMSModel.h"

@interface YXBindViewModel : NSObject
- (void)sendSMS:(YXSendSMSModel *)smsModel finish:(finishBlock)block;
- (void)requestGraphCodeMobile:(NSString *)mobile finish:(finishBlock)block;
- (void)bindPhone:(YXBindModel *)model finish:(finishBlock)block;
@end
