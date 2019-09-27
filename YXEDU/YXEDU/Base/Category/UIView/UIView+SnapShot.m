//
//  UIView+SnapShot.m
//  YXEDU
//
//  Created by yao on 2018/11/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIView+SnapShot.h"

@implementation UIView (SnapShot)
- (UIImage *)snapShot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
