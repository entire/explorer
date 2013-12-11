//
//  KHViewController.h
//  explorer
//
//  Created by Kosuke Hata on 9/18/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KHButton;

@interface KHViewController : UIViewController
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) KHButton *rightButton;
@property (nonatomic, strong) KHButton *leftButton;

@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float y_start;
@property (nonatomic) float x_start;
@property (nonatomic) float barSize;

@end
