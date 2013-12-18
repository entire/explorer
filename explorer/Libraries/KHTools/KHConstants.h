//
//  TPConstants.h
//  KHTools
//

// default macros
// for everything I use

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")
#define GET_IO  [UIApplication sharedApplication].statusBarOrientation