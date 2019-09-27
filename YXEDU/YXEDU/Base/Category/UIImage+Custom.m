//
//  UIImage+Custom.m
//  YXEDU
//
//  Created by yao on 2018/10/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect =CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageWithSize:(CGSize)size andCornerRadius:(CGFloat)cornerRadius {
    CGRect rect =CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size,NO,0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    // 3.设置裁剪区域
    [path addClip];
    
    [self drawInRect:rect];
    // 5.取出图片
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 获得圆角图片
 * rediusScale: 半径比例
 **/
-(UIImage *)makeRoundedRadius: (float) radiusScale {
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;

    CGFloat minSide = self.size.height > self.size.width ? self.size.width : self.size.height;

    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = minSide * radiusScale;

    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return roundedImage;
}
@end
