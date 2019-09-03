//
//  BaiduLocManager.m
//  YXEDU
//
//  Created by shiji on 2018/4/20.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BaiduLocManager.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

@interface BaiduLocManager ()<BMKLocationManagerDelegate, BMKLocationAuthDelegate>
@property(nonatomic, strong) BMKLocationManager *locationManager;
@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;
@end

@implementation BaiduLocManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initLocation];
    }
    return self;
}

- (void)registerBaiduKey:(NSString *)key {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:self];
}

+ (instancetype)shared {
    static BaiduLocManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [BaiduLocManager new];
    });
    return shared;
}

-(void)initLocation {
    _locationManager = [[BMKLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = NO;
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
}


- (void)startLocation:(LocationUpdateBlock)locationBlock {
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        locationBlock(location.location);
    }];
}

- (void)stopLocation {
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
}

#pragma mark -BMKLocationAuthDelegate-
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    
}
@end
