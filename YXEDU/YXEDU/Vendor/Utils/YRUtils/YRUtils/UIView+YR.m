//
//  UIView+extension.m
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "UIView+YR.h"

@implementation UIView (YR)
+ (UIView *)separateLineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
    return line;
}

- (UIImage *)snapshotSingleView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)snapshotScrollViewContent:(UIScrollView *) scrollView {
    UIImage* image =nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset= CGPointZero;
        scrollView.frame= CGRectMake(0, 0, scrollView.contentSize.width,scrollView.contentSize.height);
        
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image= UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset= savedContentOffset;
        scrollView.frame= savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if(image != nil) {
        return image;
    }
    return nil;
}

@end
