//
//  TPLoginViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/7/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KHButton.h"

@interface TPLoginViewController : PFLogInViewController <KHButtonDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@end
