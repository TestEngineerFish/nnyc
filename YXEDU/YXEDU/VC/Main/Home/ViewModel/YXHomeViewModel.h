//
//  YXMainViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"

@interface YXHomeViewModel : NSObject

- (NSInteger)itemCount;
- (id)itemModel:(NSInteger)idx;

- (NSInteger)getAllWord;
- (NSInteger)getAllLearned;
- (NSString *)getTitle;

- (NSInteger)learnedUnitCount;
- (NSInteger)readyLearnedUnitCount;

- (id)readyLearnedUnitModel:(NSInteger)idx;
- (id)learnedUnitModel:(NSInteger)idx;

// 首页刷新
- (void)refreshMainView:(finishBlock)block;

@end
