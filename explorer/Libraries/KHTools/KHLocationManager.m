//
//  KHLocationManager.m
//  KHTools
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 castanets. All rights reserved.
//

#import "KHLocationManager.h"

@interface KHLocationManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation KHLocationManager
@synthesize locationManager, currentLocation;

#pragma mark - Singleton Pattern Setup

+ (KHLocationManager *)sharedLocation {
    static KHLocationManager *_sharedLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocation = [[KHLocationManager alloc] init];
    });
    
    return _sharedLocation;
}

- (id)init {
    if (self = [super init]) {
        self.currentLocation = [[CLLocation alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)start {
    [self.locationManager startUpdatingLocation];
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    if ([self.delegate respondsToSelector:@selector(KHLocationManager:didUpdateLocations:)]) {
        [self.delegate KHLocationManager:manager didUpdateLocations:locations];
    }
}

- (CLLocation *)getLocation {
    return self.currentLocation;
}

@end
