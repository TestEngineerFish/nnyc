//
//  YXPunchModel.h
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXPunchModel : NSObject
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *learned;
@property (nonatomic, copy)NSString *days;
@property (nonatomic, copy)NSString *eng;
@property (nonatomic, copy)NSString *chs;
@property (nonatomic, copy)NSString *author;
@property (nonatomic, assign)NSInteger todayLearned;

@end

