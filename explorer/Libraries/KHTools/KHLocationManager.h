//
//  KHLocationManager.h
//  KHTools
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol KHLocationManagerDelegate <NSObject>

- (void)KHLocationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end

@interface KHLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, weak) id<KHLocationManagerDelegate> delegate;

+ (KHLocationManager *)sharedLocation;

- (void)start;
- (void)stop;

- (CLLocation *)getLocation;

@end
