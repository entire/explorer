//
//  TPSignupView.m
//  explorer
//
//  Created by Kosuke Hata on 7/12/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import "TPSignupView.h"
#import "KHButton.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+CheckForValidEmail.h"
#import "UIColor+addVeryLightGray.h"

#define TEXTFIELD_IS_NIL [self.usernameField.text length] == 0 || [self.emailField.text length] == 0 || [self.nameField.text length] == 0 || [self.passwordField.text length] == 0

@implementation TPSignupView {
    UIImageView *userImageView;
    id target_vc;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id<TPSignupViewDelegate>)parent_vc;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set delegate
        self.delegate = parent_vc;
        target_vc = parent_vc;
        self.imageIsSelected = NO;
        
        // Change button apperance
        CGSize imgSize;
        
        if (IS_IPAD) {
            imgSize = CGSizeMake(150.0f, 150.0f);
            
        } else {
            imgSize = CGSizeMake(70.0f, 70.0f);
        }
        
        float init_y;
        float field_height;
        float img_init;
        
        if (IS_IPHONE_5) {
            init_y = 150.0f;
            field_height = 40.0f;
            img_init = 45.0f;
        } else {
            init_y = 100.0f;
            field_height = 35.0f;
            img_init = 10.0f;
        }
        
        // fields
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, init_y, 240.0f, 35.0f)];
        self.usernameField.textAlignment = NSTextAlignmentCenter;
        self.usernameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.usernameField.returnKeyType = UIReturnKeyNext;
        self.usernameField.delegate = target_vc;
        self.usernameField.placeholder = @"Your Username";
        [self addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, init_y+field_height, 240.0f, 35.0f)];
        self.passwordField.textAlignment = NSTextAlignmentCenter;
        self.passwordField.secureTextEntry = YES;
        self.passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.passwordField.returnKeyType = UIReturnKeyNext;
        self.passwordField.delegate = target_vc;
        self.passwordField.placeholder = @"Your Password";
        [self addSubview:self.passwordField];
        
        self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, init_y+field_height*2, 240.0f, 35.0f)];
        self.emailField.textAlignment = NSTextAlignmentCenter;
        self.emailField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.emailField.returnKeyType = UIReturnKeyNext;
        self.emailField.delegate = target_vc;
        self.emailField.placeholder = @"Your Email";
        [self addSubview:self.emailField];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, init_y+field_height*3, 240.0f, 35.0f)];
        self.nameField.textAlignment = NSTextAlignmentCenter;
        self.nameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.nameField.returnKeyType = UIReturnKeyDone;
        self.nameField.delegate = target_vc;
        self.nameField.placeholder = @"Your Name";
        [self addSubview:self.nameField];
        
        // Make imageview button
        self.userImageButton = [[KHButton alloc] initWithButtonSizeForImage:imgSize];
        self.userImageButton.delegate = target_vc;
        self.userImageButton.frame = CGRectMake(125.0f, img_init, 70.0f, 70.0f);
        [self.userImageButton setButtonImage:[UIImage imageNamed:@"rubber_duck"]];
//        [self addSubview:self.userImageButton];
        
        self.userInteractionEnabled = YES;
        
        self.bgView = [[UIView alloc] initWithFrame:frame];
        self.bgView.alpha = 0.0f;
        self.bgView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.bgView];
        
        UILabel *addLabel = [[UILabel alloc] initWithFrame:frame];
        addLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:42];
        addLabel.textAlignment = NSTextAlignmentCenter;
        addLabel.textColor = [UIColor blackColor];
        addLabel.text = @"S I G N I N G \nY O U   U P";
        addLabel.backgroundColor = [UIColor clearColor];
        addLabel.numberOfLines = 2;
        [self.bgView addSubview:addLabel];
        
        self.usernameField.layer.borderWidth = 1.0f;
        self.usernameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.passwordField.layer.borderWidth = 1.0f;
        self.passwordField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.emailField.layer.borderWidth = 1.0f;
        self.emailField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.nameField.layer.borderWidth = 1.0f;
        self.nameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;


    }
    return self;
}

- (void)signingUserStart {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.8f;
        [self endEditing:YES];
        [UIView commitAnimations];
    }];
}

- (void)signingUserFinish {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.0f;
        [UIView commitAnimations];
    }];
}

- (BOOL)userCanSignUp {
    
    // test to see if any of the fields are nil
    if (TEXTFIELD_IS_NIL) {
        [self showAlertViewWithString:@"One of the fields seems to be empty. Try again?"];
        return NO;
    }
    
    if ([self.usernameField.text rangeOfString:@" "].location != NSNotFound) {
        [self showAlertViewWithString:@"Your username cannot have a space in it. Try again?"];
        return NO;
    }
    
    // see if the email is valid
    if (![NSString stringIsValidEmail:self.emailField.text]) {
        [self showAlertViewWithString:@"Your email doesn't seem to be valid. Try again?"];
        return NO;
    }
    
    // see if the image has been selected or not
    self.imageIsSelected = YES;
    
    if (!self.imageIsSelected) {
        [self showAlertViewWithString:@"You haven't selected an image yet. Try again?"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertView Methods

- (void)showAlertViewWithString:(NSString *)text {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil)
                                message:NSLocalizedString(text, nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cool", nil)
                      otherButtonTitles:nil] show];
}
   

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
