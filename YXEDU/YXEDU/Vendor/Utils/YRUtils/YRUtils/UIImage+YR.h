//
//  UIImage+addition.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YR)

+ (UIImage *)circularMaskImageWithSize:(CGSize)imageSize cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)color;

+ (void)roundedImage:(UIImage *)image withcornerRadius:(CGFloat)cornerRadius
          completion:(void (^)(UIImage *image))completion;

+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int)maxWidth maxHeight:(int)maxHeight;
- (UIImage *)scaleWithMaxWidth:(int)maxWidth maxHeight:(int)maxHeight;

@end
