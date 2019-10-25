//
//  YXSelectLettersViewOld.h
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWordQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXSelectLettersViewOld : UIView
@property (nonatomic, copy) void(^reverseLettersViewBlock) (NSInteger index);
- (instancetype)initWithQuestionModel:(YXQuestionModel *)quesModel;
- (void)insertLetters:(NSString *)letters atIndex:(NSInteger)index;
- (BOOL)checkResult;

@end

NS_ASSUME_NONNULL_END
