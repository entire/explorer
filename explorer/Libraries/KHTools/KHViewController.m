//
//  KHViewController.m
//  explorer
//
//  Created by Kosuke Hata on 9/18/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"

@interface KHViewController ()

@end

@implementation KHViewController

@synthesize barView;
@synthesize nameLabel;
@synthesize leftButton;
@synthesize rightButton;

@synthesize height;
@synthesize width;
@synthesize y_start;
@synthesize x_start;
@synthesize barSize;


- (id)init
{
    self = [super init];
    if (self) {
//        KHBase *base = [KHBase getBaseParameters];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


@end
