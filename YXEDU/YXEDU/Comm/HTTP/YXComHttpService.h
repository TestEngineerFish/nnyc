//
//  YXComHttpService.h
//  YXEDU
//
//  Created by shiji on 2018/6/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXVersionModel.h"
#import "YXBookModel.h"
@interface YXComHttpService : NSObject
+ (instancetype)shared;
- (void)requestUserInfo:(finishBlock)block;

- (void)setLearning:(NSString *)bookid
             finish:(finishBlock)block ;

- (void)checkVersion:(YXVersionModel *)model
            complete:(finishBlock)block;
@end
