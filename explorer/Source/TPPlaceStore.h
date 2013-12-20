//
//  TPPlaceStore.h
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPPlace;

@interface TPPlaceStore : NSObject

+ (TPPlaceStore *)sharedStore;

- (void)addPlaceToStore:(TPPlace *)place withTag:(NSString *)tag;
- (void)removePlaceFromStoreWithTag:(NSString *)tag;

@end
