//
//  NSString+CheckForValidEmail.h
//  Heavymeta
//
//  Created by Kosuke Hata on 6/18/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CheckForValidEmail)

+ (BOOL) stringIsValidEmail:(NSString *)checkString;

@end
