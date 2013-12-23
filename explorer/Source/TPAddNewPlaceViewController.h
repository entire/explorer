//
//  TPAddNewPlaceViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"
#import <MapKit/MapKit.h>
#import "TPMapViewController.h"

@class CLLocation;
@class TPGeoPointAnnotation;

@protocol TPAddNewPlaceViewControllerDelegate <NSObject>

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation;

@end

@interface TPAddNewPlaceViewController : TPMapViewController <MKMapViewDelegate>

@property (nonatomic, weak) id <TPAddNewPlaceViewControllerDelegate> delegate;

@end
