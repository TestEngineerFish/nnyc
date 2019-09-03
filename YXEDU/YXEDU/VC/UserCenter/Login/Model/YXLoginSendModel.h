//
//  YXLoginSendModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLoginSendModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *pf;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *mobile;
@end
