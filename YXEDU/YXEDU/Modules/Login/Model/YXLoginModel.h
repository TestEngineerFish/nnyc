//
//  YXLoginModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBookModel.h"
#import "YXUserModel_Old.h"

@interface YXLoginModel : NSObject<NSCoding>
@property (nonatomic, strong) YXUserModel_Old *user;
@property (nonatomic, strong) YXBookModel *learning;
@property (nonatomic, strong) NSArray <YXBookModel *>*booklist;
@property (nonatomic) NSNumber *notify;

@end
