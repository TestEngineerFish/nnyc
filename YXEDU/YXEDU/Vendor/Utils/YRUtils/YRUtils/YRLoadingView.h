//
//  YRLoadingView.h
//  pyyx
//
//  Created by Chunlin Ma on 2017/3/22.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ProgressLoading  if (!loadingView && self.dataSource.count == 0){loadingView = [YRLoadingView loadingForView:self.view];}
#define ProgressFristLoading if (!loadingView){loadingView = [YRLoadingView loadingForView:self.view];}

@interface YRLoadingView : UIView

/**
 设置颜色
 */
@property (readwrite, nonatomic) UIColor *bounceColor;
/**
 设置半径
 */
@property (readwrite, nonatomic) CGFloat radius;
/**
 设置动画延迟
 */
@property (readwrite, nonatomic) CGFloat delay;
/**
 设置动画持续时间
 */
@property (readwrite, nonatomic) CGFloat duration;

+ (instancetype)loadingView;

+ (instancetype)loadingForView:(UIView *)view;

+ (void)hideLoadingViewOnView:(UIView *)view;

- (void)startAnimating;

- (void)stopAnimating;

@end
