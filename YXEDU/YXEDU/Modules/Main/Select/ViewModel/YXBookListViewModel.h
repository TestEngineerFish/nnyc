//
//  YXBookListViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXAPI.h"

@interface YXBookListViewModel : NSObject
- (void)requestConfigure:(finishBlock)block;
- (NSArray *)titleArr;

// 首次进入时设置学习书籍
- (void)setLearning:(NSString *)bookids finish:(finishBlock)block;

// 添加书
- (void)addBook:(NSString *)bookids finish:(finishBlock)block;
@end
