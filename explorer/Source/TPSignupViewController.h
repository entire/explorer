//
//  TPSignupViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/7/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHButton.h"
#import <Parse/Parse.h>
#import "GKImagePicker.h"
#import "TPSignupView.h"

@class TPSignupViewController;
@class EGSSignUpView;

@protocol TPSignupViewControllerDelegate <NSObject>

- (void)signUpViewController:(TPSignupViewController *)signUpController didSignUpUser:(PFUser *)user withImage:(UIImage *)image;
- (void)signUpViewController:(TPSignupViewController *)signUpController didFailToSignUpWithError:(NSError *)error;
- (void)signUpViewControllerDidCancelSignUp:(TPSignupViewController *)signUpController;

@end

@interface TPSignupViewController : UIViewController <KHButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate, TPSignupViewDelegate, GKImagePickerDelegate> {
}

@property (nonatomic, strong) TPSignupView *signupView;
@property (nonatomic, weak) id <TPSignupViewControllerDelegate> delegate;
@property (nonatomic, strong) GKImagePicker *imagepicker;

@end
