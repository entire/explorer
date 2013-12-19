//
//  TPMainMapViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMainMapViewController.h"
#import <Parse/Parse.h>
#import "TPGeoPointAnnotation.h"
#import "UIViewController+MMDrawerController.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "TPUserManager.h"

@interface TPMainMapViewController ()

@end

@implementation TPMainMapViewController
{
    BOOL drawerIsOpen;
    BOOL locationWasFound;
}

- (id)init
{
    self = [super init];
    if (self) {
        //...
        locationWasFound = NO;
        drawerIsOpen = NO;
    }
    return self;
}
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    
    self.mapView = [[MKMapView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.mapView.delegate = self;
    
    [view addSubview:self.mapView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TPLocationManager sharedLocation].delegate = self;
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Map";
    
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                               landscapeImagePhone:[UIImage imageNamed:@"menu_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openMenu:)];

    // fetch objects
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.places = [NSMutableArray arrayWithArray:objects];
        [self updatePins];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openMenu:)];
    
    // add single nav tap
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] addGestureRecognizer:navSingleTap];
    
    // adding long press gesture recognizer to mapview
    UILongPressGestureRecognizer *tgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [self.mapView addGestureRecognizer:tgr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    locationWasFound = NO;
}

#pragma mark - Helper methods

- (void)updatePins
{
    for (PFObject *place in self.places) {
        [self addAnnotationsWithObject:place];
    }
}

- (void)centerMapViewToCurrentLocation
{
    CLLocationCoordinate2D location;
    location.latitude = self.currentLocation.coordinate.latitude;
    location.longitude = self.currentLocation.coordinate.longitude;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Target Action Methods

- (void)navSingleTap
{
    NSLog(@"tapped!");
    // center our map view around this geopoint
    [self centerMapViewToCurrentLocation];
    
}

- (void)openMenu:(id)sender
{
    if (!drawerIsOpen) {
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            drawerIsOpen = YES;
        }];
    } else {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            drawerIsOpen = NO;
        }];
    }
}


#pragma mark - KHButton Delegate method

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pin related methods

- (void)addAnnotationsWithObject:(PFObject *)object
{
    PFUser *holder = object[@"user"];
    NSString *objectId = holder.objectId;
    PFUser *user = [[TPUserManager sharedStore] getUserFromLocal:objectId];
    
    TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username];
    [self.mapView addAnnotation:annotation];
}


#pragma mark - TPLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    
    if (!locationWasFound) {
        [self centerMapViewToCurrentLocation];
        locationWasFound = YES;
    }
}

#pragma mark - MKMapView Delegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    //    [self centerMapViewToCurrentLocation];
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to add a pin here at %f, %f ?", coordinate.latitude, coordinate.longitude];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Have you been here?"
                                                 message:message
                                        cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:nil]
                                        otherButtonItems:[RIButtonItem itemWithLabel:@"Yes" action:^{
        [[TPLocationManager sharedLocation] pushLocationToServer:location withCompletion:^(CLLocation *yourLocaiton, PFObject *object) {
            [self addAnnotationsWithObject:object];
        }];
        
    }], nil];
    [av show];
    
}

@end
