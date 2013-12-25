//
//  TPMapDisclosureViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"
#import "KHButton.h"
#import <MapKit/MapKit.h>

@class PFObject;

@interface TPMapDisclosureViewController : KHViewController <UITableViewDataSource, UITableViewDelegate, KHButtonDelegate, MKMapViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) PFObject *selectedObject;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSArray *labels;

- (id)initWithObject:(PFObject *)object;

@end
