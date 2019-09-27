//
//  YXNinePalaceKeyBoardView.h
//  YXEDU
//
//  Created by yixue on 2019/1/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXNinePalaceKeyBoardButton.h"

NS_ASSUME_NONNULL_BEGIN

@class YXNinePalaceKeyBoardView;
@protocol YXNinePalaceKeyBoardViewDelegate <NSObject>
- (void)ninePalaceKeyBoardButtonDidClicked:(YXNinePalaceKeyBoardView *)ninePalaceKeyBoardView
                               clickButton:(YXNinePalaceKeyBoardButton *)clickedButton
                                isFinished:(BOOL)isFinished
                          indexInAnswerArr:(NSInteger)indexInAnswerArr;
@end

@interface YXNinePalaceKeyBoardView : UIView
@property (nonatomic, weak) id<YXNinePalaceKeyBoardViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
         allOptions:(NSString *)allOptions
             answer:(NSString *)answer
            options:(NSString *)options;

- (NSArray *)checkAnswer;

@property (nonatomic, assign) CGFloat gap;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, strong) NSMutableArray *userAnswerArray;
- (void)reverseKeyButtonAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
