//
//  TPMainViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/5/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMainViewController.h"
#import <Parse/Parse.h>
#import "UIViewController+MMDrawerController.h"

@interface TPMainViewController ()

@end

@implementation TPMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Map";
    
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"log out" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = rightbutton;
                                    
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

#pragma mark - Target Action Methods

- (void)openMenu:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)logout:(id)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
