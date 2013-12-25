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
#import "ELCTextFieldCell.h"

@class TPGeoPointAnnotation;

@protocol TPAddNewPlaceViewControllerDelegate <NSObject>

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation;

@end

@interface TPAddNewPlaceViewController : TPMapViewController <UIGestureRecognizerDelegate, TPDragAnnotationViewDelegate, MKMapViewDelegate,KHButtonDelegate, UITableViewDataSource, UITableViewDelegate, ELCTextFieldDelegate>

@property (nonatomic, weak) id <TPAddNewPlaceViewControllerDelegate> delegate;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) KHButton *addButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSString *currentAddress;
@property (nonatomic, strong) NSString *currentState;
@property (nonatomic, strong) NSString *currentCountry;
@property (nonatomic, strong) NSString *currentZIP;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *nameOfPlace;
@property (nonatomic, strong) NSString *whyInteresting;
@property (nonatomic, strong) UIImage *selectedImage;

- (id)initWithLocation:(CLLocation *)location;

@end
