//
//  UIImageView+YR.m
//  YRUtils
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "UIImageView+YR.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (YR)

- (void)yr_setImageUrlString:(nullable NSString *)strUrl {
    [self sd_setImageWithURL:[NSURL URLWithString:strUrl]];
}

- (void)yr_setImageUrlString:(nullable NSString *)strUrl placeholderImage:(nullable UIImage *)placeholder {
    [self sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:placeholder];
}

- (void)yr_setImageUrlString:(nullable NSString *)strUrl complete:(YRImageCompletionBlock)block {
    [self sd_setImageWithURL:[NSURL URLWithString:strUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        YRImageCacheType yrCacheType;
        switch (cacheType) {
            case SDImageCacheTypeNone:
                yrCacheType = YRImageCacheNone;
                break;
            case SDImageCacheTypeDisk:
                yrCacheType = YRImageCacheDisk;
                break;
            case SDImageCacheTypeMemory:
                yrCacheType = YRImageCacheMemory;
                break;
            default:
                yrCacheType = YRImageCacheNone;
                break;
        }
        block(image, error, yrCacheType, imageURL);
    }];
}

- (void)yr_setImageUrlString:(nullable NSString *)strUrl placeholderImage:(nullable UIImage *)placeholder complete:(YRImageCompletionBlock)block {
    [self sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        YRImageCacheType yrCacheType;
        switch (cacheType) {
            case SDImageCacheTypeNone:
                yrCacheType = YRImageCacheNone;
                break;
            case SDImageCacheTypeDisk:
                yrCacheType = YRImageCacheDisk;
                break;
            case SDImageCacheTypeMemory:
                yrCacheType = YRImageCacheMemory;
                break;
            default:
                yrCacheType = YRImageCacheNone;
                break;
        }
        block(image, error, yrCacheType, imageURL);
    }];
}


@end
