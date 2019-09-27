//
//  YXSendSMSModel.h
//  YXEDU
//
//  Created by shiji on 2018/5/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXSendSMSModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *captcha;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy)NSString *pf;
@end
