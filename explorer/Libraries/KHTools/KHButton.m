//
//  KHButton.m
//  AintuCustomer
//
//  Created by Kosuke Hata on 7/6/13.
//  Copyright (c) 2013 Aintu. All rights reserved.
//

#import "KHButton.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation KHButton {
    
    NSString *title;
    UIColor *buttonColor;
    UIColor *pressedColor;
    UIImage *buttonImage;    
    CGSize buttonSize;
    float btnHeight;
    CGRect rect;
}

@synthesize name = _name;
@synthesize delegate = _delegate;
@synthesize button = _button;
@synthesize makeSound = _makeSound;

+ (KHButton *)buttonType:(KHButtonType)type withSize:(CGSize)size {
    
    KHButton *button;
    
    if (type == kKHButtonBack) {
        
        UIColor *backColor = [UIColor colorWithRed:0.55f green:0.55f blue:0.5f alpha:1.0f];
        KHButton *backButton = [[KHButton alloc] initWithButtonSize:size withColor:backColor withTitle:@"☜"];
        backButton.button.titleLabel.font = [UIFont fontWithName:@"TitilliumText25L-400wt" size:(size.height)/1.4];
        button = backButton;
        
    } else if (type == kKHButtonNormal) {
        
        UIColor *normalColor = [UIColor colorWithRed:0.55f green:0.55f blue:0.5f alpha:1.0f];
        KHButton *normalButton = [[KHButton alloc] initWithButtonSize:size withColor:normalColor withTitle:@"☜"];
        normalButton.button.titleLabel.font = [UIFont fontWithName:@"TitilliumText25L-400wt" size:(size.height)/1.4f];
        button = normalButton;

    }
    
    return button;
}

- (id)initWithButtonSize:(CGSize)size
               withColor:(UIColor *)bColor
               withTitle:(NSString *)t {
    
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        buttonSize = size;
        rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        title = t;
        buttonColor = bColor;
        pressedColor = [self lighterColorForColor:bColor];
        
        [self basicSetup];
        [self setButtonTitle:t];
    }
    return self;
}

- (id)initWithButtonSizeForImage:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        buttonSize = size;
        //shadowColor = [UIColor darkGrayColor];
        
        [self basicSetup];
    }
    
    return self;
}

#pragma mark - Button setup

- (void)basicSetup {
    
    // make sound
    self.makeSound = YES;
    
    // setup button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height);
    [self.button addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [self.button addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.button addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchDragExit];
    [self.button addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchCancel];
    [self.button addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

    self.button.backgroundColor = buttonColor;
    [self addSubview:self.button];
    
}

#pragma mark - Target-Action Methods

- (void)buttonTouchedDown:(id)sender {
    self.button.backgroundColor = pressedColor;
    if ([self.delegate respondsToSelector:@selector(buttonWasTouchedDown:)]) {
        [self.delegate buttonWasTouchedDown:self];
    }
}

- (void)buttonTouchedUpOutside:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        self.button.backgroundColor = buttonColor;
        if ([self.delegate respondsToSelector:@selector(buttonWasTouchedUpOutside:)]) {
            [self.delegate buttonWasTouchedUpOutside:self];
        }
    }];
}

- (void)buttonTouchedUpInside:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        self.button.backgroundColor = buttonColor;
                
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(buttonWasTouchedUpInside:)]) {
            [self.delegate buttonWasTouchedUpInside:self];
        }
    }];
}


#pragma mark - Setter / Getter Methods

- (void)setButtonColor:(UIColor *)bgColor {
    
    self.button.backgroundColor = bgColor;
}

- (void)setButtonTextColor:(UIColor *)textColor {
    [self.button setTitleColor:textColor forState:UIControlStateNormal];
    [self.button setTitleColor:textColor forState:UIControlStateSelected];
    [self.button setTitleColor:textColor forState:UIControlStateHighlighted];
}

- (void)setButtonTitle:(NSString *)t {
    title = t;
    [self.button setTitle:t forState:UIControlStateNormal];
    self.button.backgroundColor = buttonColor;
}

- (void)setButtonImage:(UIImage *)image {
    buttonImage = image;
    [self.button setImage:buttonImage forState:UIControlStateNormal];
    [self.button setImage:buttonImage forState:UIControlStateSelected];
    [self.button setImage:buttonImage forState:UIControlStateHighlighted];
    
    self.button.clipsToBounds = YES;
}

- (void)changeSizeTo:(CGSize)size {
    
    buttonSize = size;
    
    self.button.frame = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height);
    
}

#pragma mark - fade in / out, hide / show

- (void)fadeButtonIn {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.button.alpha = 1.0f;
        [UIView commitAnimations];
    }];
    
}

- (void)fadeButtonOut {
    [UIView animateWithDuration:0.5 animations:^{
        self.button.alpha = 0.f;
        [UIView commitAnimations];
    }];
    
}

- (void)hideButton {
    self.button.alpha = 0.0f;
}

- (void)showButton {
    self.button.alpha = 1.0f;
}



#pragma mark - UIFont Methods

- (void)setButtonFont:(NSString *)font withSize:(float)size {
    
    self.button.titleLabel.font = [UIFont fontWithName:font size:size];
}

- (void)setCornerRadius:(float)cornerRadius {
    
    self.button.layer.cornerRadius = cornerRadius;
    
}

#pragma mark - UIColor Additions

- (UIColor *)lighterColorForColor:(UIColor *)c {
    CGFloat h, s, b, a;
    if ([c getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c {
    
    CGFloat h, s, b, a;
    if ([c getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}


@end
