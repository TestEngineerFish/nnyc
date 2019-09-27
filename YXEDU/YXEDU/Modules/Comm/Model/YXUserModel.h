//
//  YXUserModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXUserModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *speech;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *user_bind;
@property (nonatomic, strong) NSString *last_login_pf; // 最近一次使用的登录方式
@property (nonatomic, strong) NSString *last_login_time;
@property (nonatomic, strong) NSString *userBind;
@property (nonatomic, strong) NSString *lastLoginPf; // 最近一次使用的登录方式
@property (nonatomic, strong) NSString *lastLoginTime;

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *learning_book_id;
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *learningBookId;
@property (nonatomic, strong) NSString *headImg;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSNumber *punchDays;

@end
