//
//  YXConfigBookModel.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXConfigBookModel.h"

@implementation YXConfigBookModel
- (BOOL)isLearning {
    return [self.bookId isEqualToString:[YXConfigure shared].currLearningBookId];
}
@end
