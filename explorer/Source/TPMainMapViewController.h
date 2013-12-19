//
//  TPMainMapViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KHButton.h"

@interface TPMainMapViewController : KHViewController <MKMapViewDelegate, KHButtonDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end
