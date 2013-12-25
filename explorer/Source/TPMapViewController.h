//
//  TPMapViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"
#import "TPLocationManager.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface TPMapViewController : KHViewController <TPLocationManagerDelegate, MKMapViewDelegate>
{
    BOOL locationWasFound;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentLocation;

- (void)centerMapViewToCurrentLocation;
- (void)addAnnotationsWithObject:(PFObject *)object;
- (void)addAllPFObjectAnnotations:(NSArray *)pins;


@end
