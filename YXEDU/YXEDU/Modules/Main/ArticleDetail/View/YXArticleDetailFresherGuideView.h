//
//  YXArticleDetailFresherGuideView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/6.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXArticleDetailFresherGuideView;
@protocol YXArticleDetailFresherGuideViewDelegate <NSObject>

- (CGRect)fresherGuideViewBlankArea:(YXArticleDetailFresherGuideView *)frensherVIew stepIndex:(NSInteger)step;
- (void)stepPrecondition:(NSInteger)step;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YXArticleDetailFresherGuideView : UIView

+ (YXArticleDetailFresherGuideView *)showGuideViewToView:(UIView *)view delegate:(id<YXArticleDetailFresherGuideViewDelegate>)delegate;
+ (BOOL)isFresherGuideShowed;

@end

NS_ASSUME_NONNULL_END
