//
//  TPMapOverlay.m
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapOverlay.h"
#import "TPLocationManager.h"

@implementation TPMapOverlay

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(48.85883, 2.2945);
}

- (MKMapRect)boundingMapRect
{
    CLLocation *location = [[TPLocationManager sharedLocation] getLocation];
    CLLocationCoordinate2D coords = location.coordinate;
    
    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(coords.latitude + 0.01, coords.longitude + 0.01));
    MKMapPoint upperRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(coords.latitude - 0.01, coords.longitude + 0.01));
    MKMapPoint bottomLeft  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(coords.latitude - 0.01, coords.longitude - 0.01));
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - upperRight.x), fabs(upperLeft.y - bottomLeft.y));
    
    return bounds;
}

@end
