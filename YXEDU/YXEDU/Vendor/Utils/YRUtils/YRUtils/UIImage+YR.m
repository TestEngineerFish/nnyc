//
//  UIImage+addition.m
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "UIImage+YR.h"

@implementation UIImage (YR)

+ (UIImage *)circularMaskImageWithSize:(CGSize)imageSize cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, imageSize.height / 2);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), 0, 0, imageSize.width / 2, 0, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), imageSize.width, 0, imageSize.width, imageSize.height / 2, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), imageSize.width, imageSize.height, imageSize.width / 2, imageSize.height, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), 0, imageSize.height, 0, imageSize.height / 2, radius);
    
    CGContextClosePath(UIGraphicsGetCurrentContext());
    [color setFill];
    CGContextEOFillPath(UIGraphicsGetCurrentContext());
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (void)roundedImage:(UIImage *)image withcornerRadius:(CGFloat)cornerRadius
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:cornerRadius] addClip];
        // Draw your image
        [image drawInRect:rect];
        
        // Get the image, here setting the UIImageView image
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        dispatch_async( dispatch_get_main_queue(), ^{
            if (completion) {
                completion(roundedImage);
            }
        });
    });
}

+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight {
    return [image scaleWithMaxWidth:maxWidth maxHeight:maxHeight];
}

- (UIImage *)scaleWithMaxWidth:(int)maxWidth maxHeight:(int)maxHeight;{
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width <= maxWidth && height <= maxHeight) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > maxWidth || height > maxHeight) {
        CGFloat ratio = width/height;
        
        if (ratio > 1) {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
