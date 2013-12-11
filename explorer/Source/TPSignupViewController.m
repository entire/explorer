//
//  TPSignupViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/7/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPSignupViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "KHButton.h"
#import "UIColor+addVeryLightGray.h"
#import "TPSignupView.h"
#import "NSString+CheckForValidEmail.h"
#import "GKImagePicker.h"

@interface TPSignupViewController ()

@end

@implementation TPSignupViewController {

}

#pragma mark UIViewController Life Cycle Methods

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.signupView = [[TPSignupView alloc] initWithFrame:view.frame andDelegate:self];
    [view addSubview:self.signupView];
    
    self.view = view;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.title = @"join";
    
    [self.signupView.usernameField becomeFirstResponder];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"TitilliumText25L-250wt" size:16], NSFontAttributeName,
                                [UIColor colorWithRed:84.0/255.0 green:124.0/255.0 blue:146.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (IS_IPAD) {
        UIInterfaceOrientation io = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(io)) {
            
            self.signupView.nameLabel.frame = CGRectMake(0.0f, 150.0f, 768.0f, 50.0f);
            self.signupView.userImageButton.frame = CGRectMake(309.0f, 150.0f, 150.0f, 150.0f);
            
            float offset_y = 380.0f;
            
            [self.signupView.usernameField setFrame:CGRectMake(259.0f, offset_y, 250.0f, 40.0f)];
            [self.signupView.passwordField setFrame:CGRectMake(259.0f, offset_y+40.0f, 250.0f, 40.0f)];
            [self.signupView.emailField setFrame:CGRectMake(259.0f, offset_y+80.0f, 250.0f, 40.0f)];
            [self.signupView.nameField setFrame:CGRectMake(259.0f, offset_y+120.0f, 250.0f, 40.0f)];
            self.signupView.signUpButton.frame = CGRectMake(668.0f, 20.0f, 50, 50);

        } else if (UIInterfaceOrientationIsLandscape(io)){
                        
            self.signupView.nameLabel.frame = CGRectMake(0.0f, 100.0f, 1024.0f, 50.0f);
            self.signupView.userImageButton.frame = CGRectMake(287.0f, 200.0f, 150.0f, 150.0f);
            
            float start_x = 527.0f;
            float offset_y = 195.f;
            
            [self.signupView.usernameField setFrame:CGRectMake(start_x, offset_y, 250.0f, 40.0f)];
            [self.signupView.passwordField setFrame:CGRectMake(start_x, offset_y+40.0f, 250.0f, 40.0f)];
            [self.signupView.emailField setFrame:CGRectMake(start_x, offset_y+80.0f, 250.0f, 40.0f)];
            [self.signupView.nameField setFrame:CGRectMake(start_x, offset_y+120.0f, 250.0f, 40.0f)];
            self.signupView.signUpButton.frame = CGRectNull;
        }

        self.signupView.backButton.frame = CGRectMake(50.0f, 20.0f, 50.0f, 50.0f);
        self.signupView.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:50];
        self.signupView.nameLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - KHButton Delegate Method

- (void)buttonWasTouchedUpInside:(KHButton *)button {
    
    if (button == self.signupView.backButton) {
        // clicked the back button
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (button == self.signupView.signUpButton) {
        // clicked the sign up button
        [self signUpButtonPressed];
        
    } else if (button == self.signupView.userImageButton) {
        // clicked the image button
        [self addImageTapped];
    }
}

#pragma mark - User Sign Up methods

- (void)signUpButtonPressed {
    NSLog(@"sign user up was pressed! trying to save now");
    
    // check if user can sign up
    if ([self.signupView userCanSignUp]) {
        
        // create user + setup
        PFUser *user = [PFUser user];
        NSString *username = [self.signupView.usernameField.text lowercaseString];
        NSString *email = [self.signupView.emailField.text lowercaseString];
        [user setUsername:username];
        [user setEmail:email];
        [user setPassword:self.signupView.passwordField.text];
        [user setObject:self.signupView.nameField.text forKey:@"additional"];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            // change ui to dim out bg view
            [self.signupView signingUserFinish];
            
            if (!error) {
                NSLog(@"signing in user was successful");

                // save it to parse
                NSString *userID = [NSString stringWithFormat:@"%@", user.objectId];
                
                // set userID and save it
                [user setObject:userID forKey:@"userID"];
                [user saveInBackgroundWithBlock:nil];
                
                // upload user image
                [self.delegate signUpViewController:self didSignUpUser:user withImage:self.signupView.userSelectedImage];
                
            } else {
                // send delegate
                [self.delegate signUpViewController:self didFailToSignUpWithError:error];
            }
        }];
                
        // make UI changes - prep for popping
        [self.signupView signingUserStart];
    }
}

#pragma mark - GKImagePicker delegate methods

- (void)addImageTapped {

    [self.signupView endEditing:YES];
    
    GKImagePicker *picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(320.0, 320.0);    // (Optional) Default: CGSizeMake(320., 320.)
    picker.cropper.rescaleImage = YES;                     // (Optional) Default: YES
    picker.cropper.rescaleFactor = 2.0;                    // (Optional) Default: 1.0
    picker.cropper.dismissAnimated = YES;                  // (Optional) Default: YES
    picker.cropper.overlayColor = [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7];
    picker.cropper.innerBorderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.7];
    [picker presentPicker];
}

#pragma mark - UIImagePickerController Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];

    self.signupView.imageIsSelected = YES;
    self.signupView.userSelectedImage = image;
    [self.signupView.userImageButton setButtonImage:image];
    
}


-(void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image {

    self.signupView.imageIsSelected = YES;
    self.signupView.userSelectedImage = image;
    [self.signupView.userImageButton setButtonImage:image];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        
    if ([textField isEqual:self.signupView.usernameField]) {
        [self.signupView.passwordField becomeFirstResponder];
    } else if ([textField isEqual:self.signupView.passwordField]) {
        [self.signupView.emailField becomeFirstResponder];
    } else if ([textField isEqual:self.signupView.emailField]) {
        [self.signupView.nameField becomeFirstResponder];
    } else if ([textField isEqual:self.signupView.nameField]) {
        [self signUpButtonPressed];
    }
    
    return YES;
}


@end
