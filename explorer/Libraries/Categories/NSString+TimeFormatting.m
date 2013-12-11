//
//  NSString+TimeFormatting.m
//  egsv3
//
//  Created by Kosuke Hata on 12/11/12.
//  Copyright (c) 2012 Circle Time. All rights reserved.
//

#import "NSString+TimeFormatting.h"

@implementation NSString (TimeFormatting)

+ (NSString *)timeFormatted:(int)totalSeconds {
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02dhr: %02dm: %02ds",hours, minutes, seconds];
}

+ (NSString *)timeForVideo:(int)totalSeconds {
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
@end
