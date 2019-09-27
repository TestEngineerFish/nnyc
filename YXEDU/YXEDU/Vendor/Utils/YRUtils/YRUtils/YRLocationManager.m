//
//  YRLocationManager.m
//  pyyx
//
//  Created by xulinfeng on 2017/2/13.
//  Copyright © 2016年 朋友印象. All rights reserved.
//

#import "YRLocationManager.h"
#import "YRCommon.h"

NSString * const YRLocationManagerArchiverFilename = @"com.pyyx.archiver.location";

@interface YRLocationHandler : NSObject

@property (nonatomic, copy) void (^completion)(CLLocation *location, NSError *error);

@property (nonatomic, copy) NSString *tag;

- (instancetype)initWithTag:(NSString *)tag completion:(void (^)(CLLocation *location, NSError *error))completion;

@end

@implementation YRLocationHandler

- (void)dealloc{
    self.completion = nil;
}

- (instancetype)initWithTag:(NSString *)tag completion:(void (^)(CLLocation *location, NSError *error))completion;{
    self = [super init];
    if (self) {
        self.tag = tag;
        self.completion = completion;
    }
    return self;
}

@end

@interface YRLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) MDMulticastDelegate<CLLocationManagerDelegate> *delegates;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) CLLocation *lastestLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray<YRLocationHandler *> *locationHandlers;

@property (nonatomic, strong) NSTimer *locationSleepTimer;

@property (nonatomic, strong) NSTimer *locationNotRespondDelayTimer;

@end

@implementation YRLocationManager

- (void)dealloc{
    [self stopUpdatingLocation];
    [self _invalidateLocationSleepTimer];
    
    self.locationManager = nil;
    self.location = nil;
    self.delegates = nil;
}

+ (instancetype)sharedInstance{
    static YRLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [YRLocationManager new];
    });
    return locationManager;
}

- (id)init{
    self = [super init];
    if (self) {
        self.notRespondDelayInterval = 3.f;
        self.locationSleepDelayIntervel = 5.f;
        self.lastestLocationValidIntervel = 20.f;
    }
    return self;
}

#pragma mark - accessor

- (MDMulticastDelegate<CLLocationManagerDelegate> *)delegates{
    if (!_delegates) {
        _delegates = [MDMulticastDelegate<CLLocationManagerDelegate> new];
    }
    return _delegates;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableArray *)locationHandlers{
    if (!_locationHandlers) {
        _locationHandlers = [NSMutableArray array];
    }
    return _locationHandlers;
}

- (BOOL)shouldStopLocationService{
    return ![[self delegates] count] && ![[self locationHandlers] count];
}

- (YRLocationHandler *)locationHandlerWithTag:(NSString *)tag{
    return [[[self locationHandlers] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %@", tag]] firstObject];
}

#pragma mark - public

- (void)startUpdatingLocation{
    [self _readArchiver];
    [[self locationManager] requestWhenInUseAuthorization];
    [[self locationManager] startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [[self locationManager] stopUpdatingLocation];
}

- (void)registerLocationHandlerWithTag:(NSString *)tag completion:(void (^)(CLLocation *location, NSError *error))completion{
    if ([self location] && [[NSDate date] timeIntervalSinceDate:[[self location] timestamp]] < [self lastestLocationValidIntervel]) {
        completion([self location], nil);
    } else {
        [self startUpdatingLocation];
        [self _invalidateLocationSleepTimer];
        if (![self locationHandlerWithTag:tag]) {
            [[self locationHandlers] addObject:[[YRLocationHandler alloc] initWithTag:tag completion:completion]];
        }
        if (![self locationNotRespondDelayTimer]) {
            [self _fireNotRespondDelayTimer];
        }
    }
}

- (void)registerLocationDelegate:(id<CLLocationManagerDelegate>)delegate;{
    [[self delegates] removeDelegate:delegate];
    [[self delegates] addDelegate:delegate];
    
    [self _invalidateLocationSleepTimer];
    
    [self startUpdatingLocation];
}

- (void)removeLocationDelegate:(id<CLLocationManagerDelegate>)delegate;{
    [[self delegates] removeDelegate:delegate];
}

- (void)removeLocationHandlerWithTag:(NSString *)tag;{
    YRLocationHandler *handler = [self locationHandlerWithTag:tag];
    
    [[self locationHandlers] removeObject:handler];
}

#pragma mark - private

- (void)_executeLocationHandler;{
    [self _executeLocationHandlerWithError:nil];
}

- (void)_executeLocationHandlerWithError:(NSError *)error;{
    for (YRLocationHandler *handler in [self locationHandlers]) {
        handler.completion([self location], error);
    }
    [[self locationHandlers] removeAllObjects];
}

- (void)_readArchiver{
    
    self.lastestLocation = [NSKeyedUnarchiver unarchiveObjectWithFile:SDArchiverFolder(YRLocationManagerArchiverFilename)];
}

- (void)_saveArchiver{
    [NSKeyedArchiver archiveRootObject:[self lastestLocation] toFile:SDArchiverFolder(YRLocationManagerArchiverFilename)];
}

- (void)_fireLocationSleepTimer{
    [self _invalidateLocationSleepTimer];
    self.locationSleepTimer = [NSTimer scheduledTimerWithTimeInterval:[self locationSleepDelayIntervel] target:self selector:@selector(didTriggerLocationSleepTimer:) userInfo:nil repeats:NO];
}

- (void)_invalidateLocationSleepTimer{
    if ([self locationSleepTimer]) {
        [[self locationSleepTimer] invalidate];
    }
    self.locationSleepTimer = nil;
}

- (void)_fireNotRespondDelayTimer{
    [self _invalidateNotRespondDelayTimer];
    self.locationNotRespondDelayTimer = [NSTimer scheduledTimerWithTimeInterval:[self notRespondDelayInterval] target:self selector:@selector(didTriggerLocationNotRespondDelayTimer:) userInfo:nil repeats:NO];
}

- (void)_invalidateNotRespondDelayTimer{
    if ([self locationNotRespondDelayTimer]) {
        [[self locationNotRespondDelayTimer] invalidate];
    }
    self.locationNotRespondDelayTimer = nil;
}

- (void)_updateLocation:(CLLocation *)newLocation{
    if(CLCoordinateIsZero([newLocation coordinate]) && CLLocationCoordinate2DIsValid([newLocation coordinate])){
        return;
    }
    self.location = newLocation;
    self.lastestLocation = newLocation;
    
    [self _saveArchiver];
    [self _invalidateNotRespondDelayTimer];
    [self _executeLocationHandler];
    
    if ([self shouldStopLocationService] && ![self locationSleepTimer]) {
        [self _fireLocationSleepTimer];
    }
}

- (void)_handleLocationError:(NSError *)error{
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || (state != kCLAuthorizationStatusAuthorizedAlways && state != kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self stopUpdatingLocation];
    } else {
        [self _executeLocationHandlerWithError:error];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        [[self delegates] locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    }
    [self _updateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        [[self delegates] locationManager:manager didUpdateLocations:locations];
    }
    [self _updateLocation:[locations firstObject]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
        [[self delegates] locationManager:manager didUpdateHeading:newHeading];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didDetermineState:forRegion:)]) {
        [[self delegates] locationManager:manager didDetermineState:state forRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didRangeBeacons:inRegion:)]) {
        [[self delegates] locationManager:manager didRangeBeacons:beacons inRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:rangingBeaconsDidFailForRegion:withError:)]) {
        [[self delegates] locationManager:manager rangingBeaconsDidFailForRegion:region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didEnterRegion:)]) {
        [[self delegates] locationManager:manager didEnterRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didExitRegion:)]) {
        [[self delegates] locationManager:manager didExitRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didFailWithError:)]) {
        [[self delegates] locationManager:manager didFailWithError:error];
    }
    [self _handleLocationError:error];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:monitoringDidFailForRegion:withError:)]) {
        [[self delegates] locationManager:manager monitoringDidFailForRegion:region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
        [[self delegates] locationManager:manager didChangeAuthorizationStatus:status];
    }
    if (status == kCLAuthorizationStatusNotDetermined && [manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [manager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didStartMonitoringForRegion:)]) {
        [[self delegates] locationManager:manager didStartMonitoringForRegion:region];
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManagerDidPauseLocationUpdates:)]) {
        [[self delegates] locationManagerDidPauseLocationUpdates:manager];
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManagerDidResumeLocationUpdates:)]) {
        [[self delegates] locationManagerDidResumeLocationUpdates:manager];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didFinishDeferredUpdatesWithError:)]) {
        [[self delegates] locationManager:manager didFinishDeferredUpdatesWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(locationManager:didVisit:)]) {
        [[self delegates] locationManager:manager didVisit:visit];
    }
}

#pragma mark - actions

- (IBAction)didNotifyWillEnterForeground:(id)sender{
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] &&
        (state == kCLAuthorizationStatusAuthorizedAlways || state == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self startUpdatingLocation];
    }
}

- (IBAction)didTriggerLocationSleepTimer:(id)sender{
    [self _invalidateLocationSleepTimer];
    if ([self shouldStopLocationService]) {
        [self stopUpdatingLocation];
    }
}

- (IBAction)didTriggerLocationNotRespondDelayTimer:(id)sender{
    [self _invalidateNotRespondDelayTimer];
    if ([self location]) {
        [self _executeLocationHandler];
    } else {
        [self startUpdatingLocation];
    }
}

@end

CGPoint CLPointMakeWithCoordinate(CLLocationCoordinate2D coordinate){
    return CGPointMake(coordinate.longitude, coordinate.latitude);
}

BOOL CLCoordinateIsZero(CLLocationCoordinate2D coordinate){
    return coordinate.longitude == 0 && coordinate.latitude == 0;
}

BOOL CLCoordinateEqaulToCoordinate(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2){
    return coordinate1.longitude == coordinate2.longitude && coordinate1.latitude == coordinate2.latitude;
}
