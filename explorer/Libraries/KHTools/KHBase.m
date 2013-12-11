//
//  KHBase.m
//  explorer
//
//  Created by Kosuke Hata on 9/18/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHBase.h"
#import "KHButton.h"

@implementation KHBase

@synthesize height;
@synthesize width;
@synthesize y_start;
@synthesize x_start;
@synthesize barSize;

+ (KHBase *)getBaseParameters {
    
    KHBase *rect = [[KHBase alloc] init];
    
    if (IS_IPAD) {
        
    } else {
        
        rect.width = 320.0f;
        rect.x_start = 0.0f;
        rect.barSize = 44.0f;
        
        if (IS_IPHONE_5) {
            rect.height = 548.0f;
        } else {
            rect.height = 460.0f;
        }
        
        if (IS_IOS7) {
            rect.y_start = 20.0f;
        } else {
            rect.y_start = 0.0f;
        }
        
        rect.height += rect.y_start;
    }
    
    return rect;
}

+ (CGRect)getCurrentCGRect {
    
    KHBase *rect = [self getBaseParameters];
    CGRect frame = CGRectMake(0.0f, 0.0f, rect.width, rect.height);
    
    return frame;
}

@end
