//
//  KHViewController.m
//  KHTools
//
//  Created by Kosuke Hata on 9/18/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"

@interface KHViewController ()

@end

@implementation KHViewController


- (id)init
{
    self = [super init];
    if (self) {
        KHBase *rect = [KHBase getBaseParameters];
        
        self.height = rect.height;
        self.width = rect.width;
        self.barSize = rect.barSize;
        self.y_start = rect.y_start;
        self.x_start = rect.x_start;
        
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
