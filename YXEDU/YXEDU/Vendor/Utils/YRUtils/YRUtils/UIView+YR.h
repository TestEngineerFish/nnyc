//
//  UIView+extension.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YR)
+ (UIView *)separateLineWithFrame:(CGRect)frame;
- (UIImage *)snapshotSingleView:(UIView *)view;
- (UIImage *)snapshotScrollViewContent:(UIScrollView *) scrollView;
@end
