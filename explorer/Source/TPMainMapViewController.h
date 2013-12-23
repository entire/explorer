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
#import "TPAddNewPlaceViewController.h"
#import "TPLocationManager.h"
#import "TPMapViewController.h"

@class REMenu;

@interface TPMainMapViewController : TPMapViewController <KHButtonDelegate, TPAddNewPlaceViewControllerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) REMenu *menu;

@end
