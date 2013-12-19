//
//  TPSettingsViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/11/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPSettingsViewController.h"
#import "UIViewController+MMDrawerController.h"
#import <Parse/Parse.h>

@interface TPSettingsViewController ()

@end

@implementation TPSettingsViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Settings";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openMenu:)];
    
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"log out" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)logout:(id)sender
{
    [PFUser logOut];
    [self.mm_drawerController.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
