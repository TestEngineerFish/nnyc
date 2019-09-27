//
//  UIImageView+YR.h
//  YRUtils
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YRImageCacheType) {
    YRImageCacheNone,
    YRImageCacheDisk,
    YRImageCacheMemory,
};

typedef void(^YRImageCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error,YRImageCacheType cacheType, NSURL * _Nullable imageURL);

@interface UIImageView (YR)

- (void)yr_setImageUrlString:(nullable NSString *)strUrl;
- (void)yr_setImageUrlString:(nullable NSString *)strUrl placeholderImage:(nullable UIImage *)placeholder;
- (void)yr_setImageUrlString:(nullable NSString *)strUrl complete:(nullable YRImageCompletionBlock)block;
- (void)yr_setImageUrlString:(nullable NSString *)strUrl placeholderImage:(nullable UIImage *)placeholder complete:(nullable YRImageCompletionBlock)block;
@end
