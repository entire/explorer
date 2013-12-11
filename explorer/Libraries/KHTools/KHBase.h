//
//  KHBase.h
//  explorer
//
//  Created by Kosuke Hata on 9/18/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KHBase;
@class KHButton;

@interface KHBase : NSObject

@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float y_start;
@property (nonatomic) float x_start;
@property (nonatomic) float barSize;

+ (KHBase *)getBaseParameters;
+ (CGRect)getCurrentCGRect;

@end
