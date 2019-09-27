//
//  YXStudyResultModel.h
//  YXEDU
//
//  Created by yao on 2018/11/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordDetailModel.h"

@interface YXStudiedWordBrefInfo : NSObject
@property (nonatomic, copy)NSString *wordId;
@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, strong)YXWordDetailModel *wordDetailModel;
// 错词本
@property (nonatomic, assign)BOOL right;
@end


@interface YXStudyResultModel : NSObject
@property (nonatomic, copy)NSString *learnTime;
@property (nonatomic, copy)NSMutableArray *words;
@property (nonatomic, copy)NSArray *badgeIds;

@property (nonatomic, copy)NSString *sum;
@property (nonatomic, copy)NSString *right;
@end

