//
//  TPMapViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapViewController.h"
#import "TPGeoPointAnnotation.h"
#import <Parse/Parse.h>
#import "TPUserManager.h"

@interface TPMapViewController ()

@end

@implementation TPMapViewController

- (id)init
{
    self = [super init];
    if (self) {
        locationWasFound = NO;
    }
    return self;
}


- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    view.backgroundColor = [UIColor whiteColor];
    
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

    // delegate setup
    [TPLocationManager sharedLocation].delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self centerMapViewToCurrentLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    locationWasFound = NO; // reset location
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

#pragma mark - Helper Methods

- (void)centerMapViewToCurrentLocation
{
    CLLocation *centerLocation;
    
    if (!locationWasFound) {
        centerLocation = [[TPLocationManager sharedLocation] getLastKnownLocation];
    } else {
        centerLocation = [[TPLocationManager sharedLocation] getGPSLocation];
    }
    
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

- (void)addAnnotationsWithObject:(PFObject *)object
{
    PFUser *holder = object[@"user"];
    NSString *objectId = holder.objectId;
    PFUser *user = [[TPUserManager sharedStore] getUserFromLocal:objectId];
    
    TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username];
    [self.mapView addAnnotation:annotation];
}

- (void)addAllPFObjectAnnotations:(NSMutableArray *)pins
{
    for (PFObject *pin in pins) {
        [self addAnnotationsWithObject:pin];
    }
}





@end
