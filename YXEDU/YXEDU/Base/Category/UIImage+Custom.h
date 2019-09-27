//
//  UIImage+Custom.h
//  YXEDU
//
//  Created by yao on 2018/10/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Custom)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
- (UIImage *)imageWithSize:(CGSize)size andCornerRadius:(CGFloat)cornerRadius;
-(UIImage *)makeRoundedRadius: (float) radiusScale;
@end

NS_ASSUME_NONNULL_END
