//
//  YXPersonalBindModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXPersonalBindModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *bind_pf;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *openid;
@end
