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
#import "TPMapDisclosureViewController.h"
#import "UIAlertView+Blocks.h"
#import "TPMapOverlay.h"
#import "TPMapOverlayRenderer.h"
#import "TPUserManager.h"
#import "TPPinAnnotationView.h"
#import "REMenu.h"
#import "TPAddNewPlaceViewController.h"

@interface TPMainMapViewController ()

@end

@implementation TPMainMapViewController
{
    BOOL drawerIsOpen;
}

- (id)init
{
    self = [super init];
    if (self) {
        drawerIsOpen = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Map";
    
    // Do any additional setup after loading the view.
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"TitilliumText25L-250wt" size:16], NSFontAttributeName,
                                [UIColor colorWithRed:84.0/255.0 green:124.0/255.0 blue:146.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    
    // adding navigation button items
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(menuButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addNewPlace:)];


    // fetch objects
    PFQuery *query = [PFQuery queryWithClassName:@"Places"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.places = [[NSMutableDictionary alloc] init];
        
        for (PFObject *object in objects) {
            [self.places setObject:object forKey:object.objectId];
        }
        
        [self addAllPFObjectAnnotations:objects];
    }];
    
    // adding long press gesture recognizer to mapview
    UILongPressGestureRecognizer *tgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(handleGesture:)];
    [self.mapView addGestureRecognizer:tgr];
}

#pragma mark - Target Action Methods

- (void)menuButtonPressed:(id)sender
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

- (void)addNewPlace:(id)sender
{
    TPAddNewPlaceViewController *vc = [[TPAddNewPlaceViewController alloc] initWithLocation:self.currentLocation];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
    NSString *tag = object.objectId;
    
    TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username andTag:tag];
    
    [self.mapView addAnnotation:annotation];
}


#pragma mark - MKMapView Delegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    //    [self centerMapViewToCurrentLocation];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        TPPinAnnotationView *annotationView = (TPPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
        
        TPGeoPointAnnotation *identifier = (TPGeoPointAnnotation *)annotation;
        PFObject *obj = [self.places objectForKey:identifier.tag];
        NSLog(@"place: %@", obj[@"nameOfPlace"]);
        
        if (!annotationView) {
            annotationView = [[TPPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.canShowCallout = YES;
            annotationView.draggable = YES;
            annotationView.animatesDrop = YES;
            annotationView.tagString = identifier.tag;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        }
        
        return annotationView;
        
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    TPPinAnnotationView *annotationView = (TPPinAnnotationView *)view;
    PFObject *object = [self.places objectForKey:annotationView.tagString];
    
    NSLog(@"clicked! : %@", object[@"nameOfPlace"]);
    TPMapDisclosureViewController *vc = [[TPMapDisclosureViewController alloc] initWithObject:object];
    [self.navigationController pushViewController:vc animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    TPMapOverlay *mapOverlay = (TPMapOverlay *)overlay;
    TPMapOverlayRenderer *mapOverlayRenderer = [[TPMapOverlayRenderer alloc] initWithOverlay:mapOverlay];
    
    return mapOverlayRenderer;
}

#pragma mark - gesture handler


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    /*
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to add a pin here at %f, %f ?", coordinate.latitude, coordinate.longitude];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Have you been here?"
                                                 message:message
                                        cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:nil]
                                        otherButtonItems:[RIButtonItem itemWithLabel:@"Yes" action:^{
        [[TPLocationManager sharedLocation] pushLocationToServer:location
                                                  withCompletion:^(CLLocation *yourLocaiton, PFObject *object) {
             PFUser *holder = object[@"user"];
             NSString *objectId = holder.objectId;
             PFUser *user = [[TPUserManager sharedStore] getUserFromLocal:objectId];
             
             TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username];
             [self.mapView addAnnotation:annotation];
        }];
        
    }], nil];
    [av show];*/
}

#pragma mark - TPAddNewPlace ViewController delegate method

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation
{
    [self.mapView addAnnotation:annotation];
}

@end
