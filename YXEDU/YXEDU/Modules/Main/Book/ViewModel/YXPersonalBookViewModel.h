//
//  YXPersonalBookViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXAPI.h"

@interface YXPersonalBookViewModel : NSObject

- (NSInteger)rowCount;
- (id)rowModel:(NSInteger)idx;

- (NSInteger)getAllWord;
- (NSInteger)getAllLearned;
- (id)getLearningModel;

- (NSString *)getImageUrl:(NSInteger)idx;
- (NSString *)getBookName:(NSInteger)idx;
- (NSString *)getBookId:(NSInteger)idx;

- (NSString *)getLearnCoverUrl;
- (NSString *)getLearnBookName;

- (NSInteger)getAllOtherWord:(NSInteger)idx;
- (NSInteger)getAllOtherLearned:(NSInteger)idx;
- (NSInteger)getAllOtherQuestioCount:(NSInteger)idx;


- (void)getBookList:(finishBlock)block;
- (void)setLearning:(NSString *)bookids finish:(finishBlock)block;
- (void)delBook:(id)bookDelModel finish:(finishBlock)block;
@end
