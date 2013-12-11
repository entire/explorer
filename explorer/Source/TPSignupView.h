//
//  TPSignupView.h
//  explorer
//
//  Created by Kosuke Hata on 7/12/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPSignupViewDelegate <NSObject>

@end

@class EGSNameLabel;
@class EGSButton;

@interface TPSignupView : KHView

- (id)initWithFrame:(CGRect)frame andDelegate:(id<TPSignupViewDelegate>)parent_vc;

@property (nonatomic, weak) id<TPSignupViewDelegate> delegate;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *fieldsBackground;
@property (nonatomic, strong) KHButton *signUpButton;
@property (nonatomic, strong) KHButton *backButton;
@property (nonatomic, strong) UIImage *userSelectedImage;
@property (nonatomic, strong) KHButton *userImageButton;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) BOOL imageIsSelected;

- (void)signingUserStart;
- (void)signingUserFinish;
- (BOOL)userCanSignUp;

@end
