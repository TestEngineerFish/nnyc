//
//  UIImageView+YRNetwork.h
//  YRNetwork
//
//  Created by pyyx on 2018/5/11.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YRNetwork)

//TODO Do Nothing
- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;


+ (void)downloadImageWithUrl:(NSString *)url
                     success:(void (^)(UIImage *image))success
                     failure:(void (^)(NSError *error))failure;
@end
