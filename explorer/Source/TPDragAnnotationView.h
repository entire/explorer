//
//  TPDragAnnotationView.h
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol TPDragAnnotationViewDelegate <NSObject>
@required
- (void)movedAnnotation:(MKPointAnnotation *)annotation;
@end

@interface TPDragAnnotationView : MKAnnotationView {

    BOOL isMoving;
    float touchXOffset;
    float touchYOffset;
}

@property (nonatomic, weak) id <TPDragAnnotationViewDelegate> delegate;
@property (nonatomic, strong) MKMapView *mapView;

@end
