//
//  YXBookInfoModel.h
//  YXEDU
//
//  Created by yao on 2018/10/18.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXBookInfoModel : NSObject
@property (nonatomic, assign)NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, assign)BOOL learnedStatus;
@property (nonatomic, assign)NSString *wordCount;
@property (nonatomic, assign)NSString *learnedCount;
@property (nonatomic, assign)NSInteger planNum;
@property (nonatomic, assign)NSString *unitNum;
@property (nonatomic, copy) NSString *resUrl;
@property (nonatomic, copy)NSString *totalLearning;
@property (nonatomic,readonly, assign, getter=isLearning)  BOOL learning;
@end

