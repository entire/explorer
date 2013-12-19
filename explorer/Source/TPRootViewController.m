//
//  TPRootViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/9/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPRootViewController.h"
#import "EAIntroView.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "TPMainMapViewController.h"
#import "KHButton.h"
#import "MMDrawerVisualState.h"
#import <Parse/Parse.h>
#import "TPLoginViewController.h"
#import "TPSignupViewController.h"
#import "TPMenuViewController.h"

@interface TPRootViewController ()

@end

@implementation TPRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        //...
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    
    UIImageView *titleicon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 124, 160, 160)];
    titleicon.image = [UIImage imageNamed:@"titleicon"];
    [view addSubview:titleicon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 284, 160, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"e x p l o r e r";
    label.textColor = [UIColor colorWithRed:84.0/255.0 green:124.0/255.0 blue:146.0/255.0 alpha:1];
    label.font = [UIFont fontWithName:@"TitilliumText25L-250wt" size:22];
    [view addSubview:label];
    
    CGSize buttonSize = CGSizeMake(220, 40);
    UIColor *loginColor = [UIColor colorWithRed:59.0/255.0 green:95.0/255.0 blue:114.0/255.0 alpha:1];
    UIColor *signUpColor = [UIColor colorWithRed:36.0/255.0 green:64.0/255.0 blue:79.0/255.0 alpha:1];
    
    self.loginButton = [[KHButton alloc] initWithButtonSize:buttonSize withColor:loginColor withTitle:@"l o g  i n"];
    self.loginButton.delegate = self;
    self.loginButton.frame = CGRectMake(50, 400, 220, 40);
    self.loginButton.tag = kKHButtonTypeLogin;
    [self.loginButton setButtonFont:@"TitilliumText25L-250wt" withSize:15];
    [view addSubview:self.loginButton];
    
    self.signupButton = [[KHButton alloc] initWithButtonSize:buttonSize withColor:signUpColor withTitle:@"j o i n"];
    self.signupButton.delegate = self;
    self.signupButton.tag = kKHButtonTypeSignup;
    self.signupButton.frame = CGRectMake(50, 450, 220, 40);
    [self.signupButton setButtonFont:@"TitilliumText25L-250wt" withSize:15];
    [view addSubview:self.signupButton];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IOS7) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"normalLaunch"]) {
        NSLog(@"RootVC - first time launch!");
        //        [self showIntro];
        //        self.navigationController.navigationBarHidden = YES;
    } else {
        NSLog(@"RootVC - normal launch!");
        self.navigationController.navigationBarHidden = NO;
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // USER SIGN IN STATUS CHECK
    if (![PFUser currentUser]) { // User is not logged in
        NSLog(@"RootVC - viewDidAppear and user is not logged in");
        [self showButtons];
        
    } else {
        NSLog(@"RootVC - viewDidAppear and user is logged in!");
        self.navigationController.navigationBarHidden = YES;
        
        TPMainMapViewController *vc = [[TPMainMapViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        TPMenuViewController *menu = [[TPMenuViewController alloc] init];
        
        MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:nav
                                                                                leftDrawerViewController:menu];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [drawerController setMaximumRightDrawerWidth:280.0];
        [drawerController setShowsShadow:NO];
        [drawerController setShouldStretchDrawer:NO];
        
        [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            
            if(block){
                block(drawerController, drawerSide, percentVisible);
            }
        }];
        
        [self.navigationController pushViewController:drawerController animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (void)showIntro
{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"YOU CAN DO THIS";
    page1.desc = @"and then this happens";
    page1.titleImage = [UIImage imageNamed:@"1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"AND THEN THIS";
    page2.desc = @"wow i never knew you could do that";
    page2.titleImage = [UIImage imageNamed:@"2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"OH MAN THATS AWESOME";
    page3.desc = @"yeah man I know, so awesome";
    page3.titleImage = [UIImage imageNamed:@"3"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds
                                                   andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)introDidFinish:(EAIntroView *)introView
{
    NSLog(@"Intro callback");
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"normalLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showButtons
{

    
}

#pragma mark - EGSButton Delegate Methods

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    if (button.tag == kKHButtonTypeLogin) {
        
        TPLoginViewController *loginVC = [[TPLoginViewController alloc] init];
        loginVC.delegate = self;
        loginVC.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    } else if (button.tag == kKHButtonTypeSignup) {
        // Customize the Sign Up View Controller
        TPSignupViewController *signupVC = [[TPSignupViewController alloc] init];
        signupVC.delegate = self;
        [self.navigationController pushViewController:signupVC animated:YES];
    }
}
#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    if (username && password && username.length && password.length)
    {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil)
                                message:NSLocalizedString(@"Make sure you fill out all of the information!", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"logged in now");
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");
    
    if (error) {
        
        NSInteger status_code = [[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"code"]] intValue];
        
        NSLog(@"%@", [error userInfo]);
        
        if (status_code == 101) {
            [self showAlertViewWithString:@"You have the wrong password or the username does not exist."];
        } else {
            [self showAlertViewWithString:@"There are some issues logging in. Try again later."];
        }
        
    }
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewController Delegate Method

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user withImage:(UIImage *)image
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    
    if (error) {
        NSInteger status_code = [[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"code"]] intValue];
        if (status_code == 101) {
            NSString *userAlert = [NSString stringWithFormat:@"Either your password is wrong, or there is no one by that username."];
            [self showAlertViewWithString:userAlert];
            
        } else {
            NSString *nameAlert = @"There seems to be some issues. Try again later.";
            [self showAlertViewWithString:nameAlert];
        }
    }
}

- (void)signUpViewControllerDidCancelSignUp:(TPSignupViewController *)signUpController
{
    
}

#pragma mark - UIAlertView Methods

- (void)showAlertViewWithString:(NSString *)text
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil)
                                message:NSLocalizedString(text, nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cool", nil)
                      otherButtonTitles:nil] show];
}


@end
