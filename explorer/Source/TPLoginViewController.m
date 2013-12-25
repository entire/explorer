//
//  TPLoginViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/7/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPLoginViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "KHButton.h"

@interface TPLoginViewController ()
@property (nonatomic, strong) KHButton *backButton;
@property (nonatomic, strong) KHButton *forgotButton;

@end

@implementation TPLoginViewController {
    
    NSString *userEmail;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.title = @"login";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"TitilliumText25L-250wt" size:16], NSFontAttributeName,
                                [UIColor colorWithRed:84.0/255.0 green:124.0/255.0 blue:146.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self.logInView setBackgroundColor:[UIColor whiteColor]];

    // Hide unnecessary views
    self.logInView.logo.hidden = YES;
    self.logInView.dismissButton.hidden = YES;
    self.logInView.signUpButton.hidden = YES;
    self.logInView.facebookButton.hidden = YES;
    self.logInView.twitterButton.hidden = YES;
    self.logInView.externalLogInLabel.hidden = YES;
    self.logInView.signUpLabel.hidden = YES;
    self.logInView.usernameField.hidden = YES;
    self.logInView.passwordField.hidden = YES;
    
    // for got button color
    UIColor *fColor = [UIColor colorWithRed:84.0/255.0 green:124.0/255.0 blue:146.0/255.0 alpha:1];
    
    // Set field text color
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.placeholder = @"Username";
    [self.logInView addSubview:self.usernameField];
    [self.usernameField setFrame:CGRectMake(40.0f, 150.0f, 240.0f, 35.0f)];

    self.passwordField = [[UITextField alloc] init];
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.passwordField.delegate = self;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    [self.logInView addSubview:self.passwordField];
    [self.passwordField setFrame:CGRectMake(40.0f, 200.0f, 240.0f, 35.0f)];

    self.usernameField.layer.borderWidth = 1.0f;
    self.usernameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.passwordField.layer.borderWidth = 1.0f;
    self.passwordField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // back button
    CGSize fSize = CGSizeMake(120.0f, 25.0f);
    self.forgotButton = [[KHButton alloc] initWithButtonSize:fSize withColor:fColor withTitle:@"forgot password"];
    [self.forgotButton setButtonFont:@"HelveticaNeue-Light" withSize:10];
    self.forgotButton.delegate = self;
    self.forgotButton.frame = CGRectMake(100, 260, 120, 25);
    [self.forgotButton setCornerRadius:2.0];
    [self.logInView insertSubview:self.forgotButton atIndex:0];
    
    // setup bg view
    self.bgView = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    self.bgView.alpha = 0.0f;
    self.bgView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.bgView];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:[KHBase getCurrentCGRect]];
    addLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:42];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.textColor = [UIColor blackColor];
    addLabel.text = @"L O G G N I N G \nY O U   I N";
    addLabel.backgroundColor = [UIColor clearColor];
    addLabel.numberOfLines = 2;
    [self.bgView addSubview:addLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.usernameField becomeFirstResponder];
    
    /*
    float y_start = 0.0f;
    
    if (IS_IOS7) {
        NSLog(@"it's ios7");
        y_start = 20.0f;
    }
    
    float buttonWidth;

    if (IS_IPAD) {
        UIInterfaceOrientation io = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(io)) {
            
            buttonWidth = 368.0f;

//            self.nameLabel.frame = CGRectMake(0.0f, y_start+150.0f, 768.0f, 50.0f);
//            self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:50];
            
            [self.usernameField setFrame:CGRectMake(259.0f, 290.0f, 250.0f, 45.0f)];
            [self.passwordField setFrame:CGRectMake(259.0f, 330.0f, 250.0f, 45.0f)];
            self.forgotButton.frame = CGRectMake(100.0f+259.0f, 410.0f, 50.0f, 20.0f);
            
        } else if (UIInterfaceOrientationIsLandscape(io)){
            
            buttonWidth = 424.0f;

//            self.nameLabel.frame = CGRectMake(0.0f, y_start+150.0f, 1024.0f, 50.0f);
//            self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:50];
            
            [self.usernameField setFrame:CGRectMake(387.0f, 220.0f, 250.0f, 45.0f)];
            [self.passwordField setFrame:CGRectMake(387.0f, 270.0f, 250.0f, 45.0f)];
            self.forgotButton.frame = CGRectMake(100.0f+387.0f, 340.0f, 50.0f, 20.0f);
            
        }
        
        self.backButton.frame = CGRectMake(0, y_start, 60.0f, 60.0f);

        
    } else {
        // Set frame for elements
        if (IS_IPHONE_5) {
//            self.nameLabel.frame = CGRectMake(0.0f, y_start+85.0f, 320.0f, 50.0f);
            
            [self.usernameField setFrame:CGRectMake(40.0f, 150.0f, 240.0f, 35.0f)];
            [self.passwordField setFrame:CGRectMake(40.0f, 200.0f, 240.0f, 35.0f)];
            
            self.forgotButton.frame = CGRectMake(135, 275, 50, 20);
            
        } else {
//            self.nameLabel.frame = CGRectMake(0, y_start+65, 320, 50);
            
            [self.usernameField setFrame:CGRectMake(40.0f, 120.0f, 240.0f, 35.0f)];
            [self.passwordField setFrame:CGRectMake(40.0f, 160.0f, 240.0f, 35.0f)];
            
            self.forgotButton.frame = CGRectMake(135, 215, 50, 20);

        }

        [self.view bringSubviewToFront:self.logInView];
    }
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Target-Action methods


- (void)displaySignUpView:(id)sender {
    [self.navigationController pushViewController:self.signUpController animated:YES];
}

- (void)buttonWasTouchedUpInside:(KHButton *)button {
    
    if (button == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (button == self.forgotButton) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Recover Your Passowrd"
                                                    message:@"Enter your email address here to recover your password" delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        [av show];
        
    }
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    userEmail = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"pressed!");
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordField]) {
        self.usernameField.text = [self.usernameField.text lowercaseString];

        [PFUser logInWithUsernameInBackground:self.usernameField.text
                                     password:self.passwordField.text
                                        block:^(PFUser *user, NSError *error) {
                                            [self loggningUserFinish];
                                            if (user) {
                                                [self.delegate logInViewController:self didLogInUser:user];
                                            } else {
                                                [self.delegate logInViewController:self didFailToLogInWithError:error];
                                            }
                                        }];
        [self loggningUserStart];
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"0");
    } else if (buttonIndex == 1) {
        NSLog(@"1");
        
        NSLog(@"%@",userEmail);
    } 
}

- (void)loggningUserStart {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.8f;
        [self.logInView endEditing:YES];
        [UIView commitAnimations];
    }];
}

- (void)loggningUserFinish {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.0f;
        [UIView commitAnimations];
    }];
}






@end