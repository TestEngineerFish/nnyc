//
//  YXRankBaseInfo.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXRankBaseInfo : NSObject
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, assign) NSInteger speedTime;
@property (nonatomic, copy) NSString *correctNum;
@property (nonatomic, copy) NSString *credits;

@property (nonatomic, copy) NSString *spendTime;

@end

