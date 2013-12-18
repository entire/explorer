//
//  KHView.m
//  KHTools
//
//  Created by Kosuke Hata on 9/17/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHView.h"
#import "KHButton.h"
#import "KHBase.h"

@interface KHView ()
@end

@implementation KHView

#pragma mark - Setup Parameters

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (CGRect)getFullProperRectForView {
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.width, self.height);
    
    return frame;
}

@end
