//
//  YRDevice.h
//  pyyx
//
//  Created by Chunlin Ma on 16/7/11.
//  Copyright © 2016年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YRDevice : NSObject

+ (NSString *)OSVersion;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)modelVersion;

@end
