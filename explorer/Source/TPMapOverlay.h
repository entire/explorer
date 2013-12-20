//
//  TPMapOverlay.h
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TPMapOverlay : NSObject <MKOverlay>
{
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (MKMapRect)boundingMapRect;

@end