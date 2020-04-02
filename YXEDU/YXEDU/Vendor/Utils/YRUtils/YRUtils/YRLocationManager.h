//
//  YRLocationManager.h
//  pyyx
//
//  Created by xulinfeng on 2017/2/13.
//  Copyright © 2016年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MDMulticastDelegate.h"

@interface YRLocationManager : NSObject

/**
 *  定位睡眠延迟间隔
 *  当没有任何回调或者代理需要执行时，定位服务会继续执行该时间间隔，直到时间截止后，关闭定位服务
 *  默认为5秒钟
 */
@property (nonatomic, assign) NSTimeInterval locationSleepDelayIntervel;

/**
 *  位置更新的有效时间，如果距上次更新的时间超过该时间，则需要重新启动定位服务
 *  默认为20秒
 */
@property (nonatomic, assign) NSTimeInterval lastestLocationValidIntervel;

/**
 *  最长未响应时间，如时间内没有对回调进行响应，则以上一次的信息来响应
 *  默认为3秒
 */
@property (nonatomic, assign) NSTimeInterval notRespondDelayInterval;

/**
 *  当前定位到的用户位置信息
 */
@property (nonatomic, strong, readonly) CLLocation *location;

/**
 *  用户最新定位到的位置, 默认为用户上一次定位的位置信息，有可能为缓存数据
 */
@property (nonatomic, strong, readonly) CLLocation *lastestLocation;

/**
 *  定位服务
 */
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

+ (instancetype)sharedInstance;

/**
 *  启动定位服务
 */
- (void)startUpdatingLocation;

/**
 *  关闭定位服务
 */
- (void)stopUpdatingLocation;

/**
 *  添加定位代理，永久执行
 *
 *  @param delegate 代理
 */
- (void)registerLocationDelegate:(id<CLLocationManagerDelegate>)delegate;

/**
 *  移除定位代理
 *
 *  @param delegate 代理
 */
- (void)removeLocationDelegate:(id<CLLocationManagerDelegate>)delegate;

/**
 *  添加定位回调，只执行一次
 *
 *  @param tag          标签，确定回调唯一性
 *  @param completion   回调
 */
- (void)registerLocationHandlerWithTag:(NSString *)tag completion:(void (^)(CLLocation *location, NSError *error))completion;

/**
 *  移除标记为tag的所有handler
 *
 *  @param tag 标记
 */
- (void)removeLocationHandlerWithTag:(NSString *)tag;

@end

/**
 *  CLLocationCoordinate2D 转换成 CGPoint
 *
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return CGPoint
 */
UIKIT_EXTERN CGPoint CLPointMakeWithCoordinate(CLLocationCoordinate2D coordinate);

/**
 *  判断 CLLocationCoordinate2D 是否为空
 *
 *  @param coordinate CLLocationCoordinate2D
 *
 *  @return 是否为空
 */
UIKIT_EXTERN BOOL CLCoordinateIsZero(CLLocationCoordinate2D coordinate);

/**
 *  判断两个CLLocationCoordinate2D是否相等
 *
 *  @param coordinate1 CLLocationCoordinate2D
 *  @param coordinate2 CLLocationCoordinate2D
 *
 *  @return 是否相等
 */
UIKIT_EXTERN BOOL CLCoordinateEqaulToCoordinate(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

