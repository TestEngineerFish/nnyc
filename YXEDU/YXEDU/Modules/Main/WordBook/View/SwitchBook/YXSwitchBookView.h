//
//  YXSeletWordsSourceNameView.h
//  YXEDU
//
//  Created by yao on 2019/2/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBaseMaskView.h"
#import "YXCurrentSeletBookInfo.h"
NS_ASSUME_NONNULL_BEGIN

@class YXSwitchBookView;
@protocol YXSwitchBookViewDelegate <NSObject>
- (void)switchBookViewTouchedToHide:(YXSwitchBookView *)switxchBookView;
- (void)switchBookViewSelectABook:(YXSwitchBookView *)switxchBookView;
@end

@interface YXSwitchBookView : YXBaseMaskView
@property (nonatomic, weak) id<YXSwitchBookViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *bookCategorys;
@property (nonatomic, strong) YXCurrentSeletBookInfo *currentSeletBookInfo;
@property (nonatomic, copy) void(^touchBlock)(void);
+ (instancetype)showSourceNameViewToView:(UIView *)view;
- (void)showAnimate;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
