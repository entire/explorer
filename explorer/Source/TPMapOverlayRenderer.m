//
//  TPMapOverlayRenderer.m
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapOverlayRenderer.h"

@implementation TPMapOverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx
{
    
    UIImage *image = [UIImage imageNamed:@"indigo_eiffel_blog.png"];
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -theRect.size.height);
    CGContextDrawImage(ctx, theRect, imageReference);
    
}

@end
