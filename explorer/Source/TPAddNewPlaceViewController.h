//
//  TPAddNewPlaceViewController.h
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "KHViewController.h"

@class CLLocation;
@class TPGeoPointAnnotation;

@protocol TPAddNewPlaceViewControllerDelegate <NSObject>

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation;

@end

@interface TPAddNewPlaceViewController : KHViewController

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, weak) id <TPAddNewPlaceViewControllerDelegate> delegate;
@end
