//
//  TPAddNewPlaceViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapViewController.h"
#import <MapKit/MapKit.h>
#import "TPLocationManager.h"
#import "TPDragAnnotationView.h"
#import "KHButton.h"

@class TPGeoPointAnnotation;

@protocol TPAddNewPlaceViewControllerDelegate <NSObject>

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation;

@end

@interface TPAddNewPlaceViewController : TPMapViewController <UIGestureRecognizerDelegate, TPDragAnnotationViewDelegate, MKMapViewDelegate,KHButtonDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <TPAddNewPlaceViewControllerDelegate> delegate;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) KHButton *addButton;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithLocation:(CLLocation *)location;

@end
