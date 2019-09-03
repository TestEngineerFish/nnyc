//
//  YXUserModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXUserModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *user_bind;
@property (nonatomic, strong) NSString *last_login_pf; // 最近一次使用的登录方式
@property (nonatomic, strong) NSString *learning_book_id;
@end
