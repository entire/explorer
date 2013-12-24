//
//  TPLocationManager.m
//  castanets
//
//  Created by Kosuke Hata
//  Copyright (c) 2013 castanets. All rights reserved.
//

#import "TPLocationManager.h"
#import <Parse/Parse.h>

@interface TPLocationManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation TPLocationManager
@synthesize locationManager, currentLocation;

#pragma mark - Singleton Pattern Setup

+ (TPLocationManager *)sharedLocation {
    static TPLocationManager *_sharedLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocation = [[TPLocationManager alloc] init];
    });
    
    return _sharedLocation;
}

- (id)init {
    if (self = [super init]) {

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

    if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        [self.delegate locationManager:manager didUpdateLocations:locations];
        
        if (self.currentLocation == nil) {
            self.currentLocation = [[CLLocation alloc] init];
            self.currentLocation = [locations lastObject];
        }
    }
}

- (void)addLastKnownLocation:(CLLocation *)lastLocation
{
    if (self.lastKnownLocation == nil) {
        self.lastKnownLocation = [[CLLocation alloc] init];
    }
    
    self.lastKnownLocation = lastLocation;
}

- (CLLocation *)getGPSLocation
{
    if (self.currentLocation != nil) {
        return self.currentLocation;
    } else {
        return nil;
    }
}

- (CLLocation *)getLastKnownLocation
{
    if (self.lastKnownLocation != nil) {
        return self.lastKnownLocation;
    } else {
        return nil;
    }
    
}

- (void)pushLocationToServer:(CLLocation *)location withCompletion:(void (^)(CLLocation *location, PFObject *object))completionBlock
{
    NSLog(@"pushing to server");
    
	if (!location) {
		return;
	}
    
    // set ACL
    PFACL *ACL = [PFACL ACL];
    [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [ACL setReadAccess:YES forUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    [ACL setPublicWriteAccess:YES];
    
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    PFObject *object = [PFObject objectWithClassName:@"Places"];
    [object setObject:geoPoint forKey:@"location"];
    [object setObject:[PFUser currentUser] forKey:@"user"];
    [object setACL:ACL];

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFUser *user = [PFUser currentUser];
            PFRelation *relation = [user relationforKey:@"Location"];
            [relation addObject:object];

            dispatch_async(dispatch_get_main_queue(), ^{
                [user saveInBackground];
            });
            
            if (completionBlock != nil) {
                completionBlock(location, object);
            }
        }
    }];
}

@end
