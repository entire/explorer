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

- (CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[TPLocationManager sharedLocation] getGPSLocation];
    CLLocationCoordinate2D coord1 = location.coordinate;

    return coord1;
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 2, 2);
    return bounds;
}
@end
