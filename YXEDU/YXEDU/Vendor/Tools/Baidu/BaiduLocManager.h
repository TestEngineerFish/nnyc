//
//  BaiduLocManager.h
//  YXEDU
//
//  Created by shiji on 2018/4/20.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef  void (^LocationUpdateBlock) (CLLocation *obj);
@interface BaiduLocManager : NSObject
+ (instancetype)shared;
- (void)registerBaiduKey:(NSString *)key;
- (void)startLocation:(LocationUpdateBlock)locationBlock;
- (void)stopLocation;
@end
