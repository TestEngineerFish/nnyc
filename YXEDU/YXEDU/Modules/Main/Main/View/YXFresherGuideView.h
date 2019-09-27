//
//  YXFresherGuideView.h
//  YXEDU
//
//  Created by yao on 2018/11/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXFresherGuideView;
@protocol YXFresherGuideViewDelegate <NSObject>
- (CGRect)fresherGuideViewBlankArea:(YXFresherGuideView *)fresherView stepIndex:(NSInteger)step;
- (void)fresherGuideViewGuideFinished:(YXFresherGuideView *)fresherView;
@end

@interface YXFresherGuideView : UIView
@property (nonatomic, weak) id<YXFresherGuideViewDelegate> delegate;
@property (nonatomic, readonly,assign) NSInteger step;
+ (YXFresherGuideView *)showGuideViewToView:(UIView *)view delegate:(id<YXFresherGuideViewDelegate>)delegate;
//+ (NSString *)fresherGuideKey;
+ (BOOL)isfresherGuideShowed;
//- (void)fresherGuideShowed;
@end

