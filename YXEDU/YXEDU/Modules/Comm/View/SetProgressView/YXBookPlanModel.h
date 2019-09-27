//
//  YXBookPlanModel.h
//  YXEDU
//
//  Created by yao on 2018/11/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXBookPlanModel : NSObject
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, assign) NSInteger planNum;
@property (nonatomic, assign) NSInteger leftWords;
@property (nonatomic, assign) BOOL theNewBook;
@property (nonatomic, assign) NSInteger todayLeftWords;

+ (YXBookPlanModel *)planModelWith:(NSString *)bookId
                           planNum:(NSInteger)planNum
                         leftWords:(NSInteger)leftWords
                    todayLeftWords:(NSInteger)todayLeftWords;
@end

