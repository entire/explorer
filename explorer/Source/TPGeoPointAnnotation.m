//
//  TPGeoPointAnnotation.m
//  explorer
//
//  Created by Kosuke Hata on 8/2/12.
//

#import "TPGeoPointAnnotation.h"

@interface TPGeoPointAnnotation()

@property (nonatomic, strong) PFObject *object;

@end

@implementation TPGeoPointAnnotation
{
    NSString *username;
}


#pragma mark - Initialization

- (id)initWithObject:(PFObject *)aObject andUsername:(NSString *)name andTag:(NSString *)tag {
    self = [super init];
    if (self) {
        _object = aObject;
        username = name;
        self.tag = tag;
        NSLog(@"added %@ -- tag: %@", aObject[@"nameOfPlace"], aObject.objectId);
        PFGeoPoint *geoPoint = self.object[@"location"];
        [self setGeoPoint:geoPoint];
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
    [self.object setObject:geoPoint forKey:@"location"];
    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotiationUpdated" object:self.object];
        }
    }];
}

#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 3;
    }
    
    _title = [NSString stringWithFormat:@"%@",self.object[@"nameOfPlace"]];
    _subtitle = [NSString stringWithFormat:@"%@ %@",self.object[@"address"], self.object[@"city"]];
}

@end
