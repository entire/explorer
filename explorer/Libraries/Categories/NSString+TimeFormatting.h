//
//  NSString+TimeFormatting.h
//  egsv3
//
//  Created by Kosuke Hata on 12/11/12.
//  Copyright (c) 2012 Circle Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormatting)

+ (NSString *)timeFormatted:(int)totalSeconds;
+ (NSString *)timeForVideo:(int)totalSeconds;

@end
