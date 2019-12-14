//
//  YXShareImageGenerator.h
//  lindash
//
//  Created by yao on 2018/12/5.
//  Copyright © 2018年 yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXPunchModel.h"
@interface YXShareImageGenerator : NSObject
+ (UIImage *)generateResultImage:(YXPunchModel *)model
                            link:(NSString *)link;
//+ (UIImage *)generateBadgeImage;
+ (UIImage *)generateBadgeImage:(UIImage *)badgeImage
                          title:(NSString *)title
                           date:(NSString *)date
                    describtion:(NSString *)des
                           link:(NSString *)link;
+ (UIImage *)generatorQRCodeImageWith:(NSString *)info;

//+ (UIImage *)generateGameResultImage:(YXGameResultModel *)model
//                            platform:(YXSharePalform)platform;
@end

