//
//  TPMainMapViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMainMapViewController.h"
#import <Parse/Parse.h>
#import "UIViewController+MMDrawerController.h"

@interface TPMainMapViewController ()

@end

@implementation TPMainMapViewController
{
    BOOL drawerIsOpen;
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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - KHButton Delegate method

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    
}

#pragma mark - Target Action Methods

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
