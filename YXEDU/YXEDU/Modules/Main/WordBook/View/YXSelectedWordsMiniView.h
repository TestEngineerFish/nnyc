//
//  YXSelectedWordsMiniView.h
//  YXEDU
//
//  Created by yao on 2019/2/27.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBookCategoryModel.h"
#define kMiniViewCloseHeight AdaptSize(70)
#define kMiniViewMaxHeigh AdaptSize(220)
#define kMiniWordCellHeigh AdaptSize(32);
NS_ASSUME_NONNULL_BEGIN


@class YXSelectedWordsMiniView;
@protocol YXSelectedWordsMiniViewDelegate <NSObject>
- (void)selectedWordsMiniViewTitleClick:(YXSelectedWordsMiniView *)selectedWordsMiniView;
- (void)selectedWordsMiniViewDeleteWords:(YXSelectWordCellModel *)selectWordCellModel;
@end

@interface YXSelectedWordsMiniView : UIView
@property (nonatomic, weak) id<YXSelectedWordsMiniViewDelegate> delegate;
@property (nonatomic, readonly ,assign,getter=isOpen) BOOL open;
@property (nonatomic, strong) NSMutableArray *selectedWords;
@end

NS_ASSUME_NONNULL_END
