//
//  TPPinAnnotationView.h
//  explorer
//
//  Created by Kosuke Hata on 12/24/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TPPinAnnotationView : MKPinAnnotationView

@property (nonatomic, strong) NSString *tagString;

@end
