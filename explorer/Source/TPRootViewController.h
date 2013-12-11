//
//  TPRootViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/9/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import "KHButton.h"
#import "TPSignupViewController.h"
#import <Parse/Parse.h>

@interface TPRootViewController : UIViewController <EAIntroDelegate, KHButtonDelegate, PFLogInViewControllerDelegate, TPSignupViewControllerDelegate>

@property (nonatomic, strong) KHButton *loginButton;
@property (nonatomic, strong) KHButton *signupButton;
@end
