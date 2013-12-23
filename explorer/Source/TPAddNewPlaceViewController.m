//
//  TPAddNewPlaceViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPAddNewPlaceViewController.h"
#import <Parse/Parse.h>
#import "TPUserManager.h"
#import "TPLocationManager.h"
#import "TPGeoPointAnnotation.h"

@interface TPAddNewPlaceViewController ()

@end

@implementation TPAddNewPlaceViewController

- (id)init
{
    self = [super init];
    if (self) {
        //...
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add New Place";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickedCancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark_icon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clickedOk:)];}

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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target action methods

- (void)clickedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickedOk:(id)sender
{
    NSLog(@"ok!");
    
    self.currentLocation = [[TPLocationManager sharedLocation] getLocation];
    
    [[TPLocationManager sharedLocation] pushLocationToServer:self.currentLocation
                                              withCompletion:^(CLLocation *yourLocaiton, PFObject *object) {
                                                  
                                                  PFUser *holder = object[@"user"];
                                                  NSString *objectId = holder.objectId;
                                                  PFUser *user = [[TPUserManager sharedStore] getUserFromLocal:objectId];
                                                  
                                                  TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username];
                                                  
                                                  if ([self.delegate respondsToSelector:@selector(userClickedOk:)]) {
                                                      [self.delegate userClickedOk:annotation];
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                  }
                                              }];
}


@end
