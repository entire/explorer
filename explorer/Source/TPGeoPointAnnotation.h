//
//  TPGeoPointAnnotation.h
//  explorer
//
//  Created by Kosuke Hata on 12/7/13.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface TPGeoPointAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(PFObject *)aObject andUsername:(NSString *)name andTag:(NSString *)tag;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *description;
@property (nonatomic, strong) NSString *tag;

@end
