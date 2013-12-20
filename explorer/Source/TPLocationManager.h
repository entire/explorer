//
//  TPLocationManager.h
//  castanets
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PFObject;

@protocol TPLocationManagerDelegate <NSObject>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end

@interface TPLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, weak) id<TPLocationManagerDelegate> delegate;

+ (TPLocationManager *)sharedLocation;

- (void)start;
- (void)stop;

- (CLLocation *)getLocation;
- (void)getLocationWithCompletion:(void (^)(CLLocation *))completionBlock;
- (void)pushLocationToServer:(CLLocation *)location withCompletion:(void (^)(CLLocation *location, PFObject *object))completionBlock;

@end
