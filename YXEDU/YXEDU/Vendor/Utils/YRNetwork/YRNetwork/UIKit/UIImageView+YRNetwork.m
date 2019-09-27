//
//  UIImageView+YRNetwork.m
//  YRNetwork
//
//  Created by pyyx on 2018/5/11.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "UIImageView+YRNetwork.h"
#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (YRNetwork)

- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block {}

+ (void)downloadImageWithUrl:(NSString *)url
                     success:(void (^)(UIImage *image))success
                     failure:(void (^)(NSError *error))failure{
    if (url.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        AFImageDownloader *downloader = [self sharedImageDownloader];
        
        //TODO 内存缓存
        UIImage *cachedImage = [downloader.imageCache imageforRequest:request withAdditionalIdentifier:nil];
        if (!cachedImage) {
            //TODO 内存缓存没有，读取硬盘缓存
            NSURLCache *urlCache = downloader.sessionManager.session.configuration.URLCache;
            NSCachedURLResponse *cacheResponse = [urlCache cachedResponseForRequest:request];
            if (cacheResponse.data) {
                cachedImage = [UIImage imageWithData:cacheResponse.data];
                
                if (success) {
                    success(cachedImage);
                    return;
                }
            }
        }
        
        [downloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
            if (success) success(responseObject);
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            if (failure) failure(error);
        }];
    }
}
@end
