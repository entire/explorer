//
//  TPPlaceStore.m
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPPlaceStore.h"
#import <Parse/Parse.h>
#import "TPPlace.h"

@implementation TPPlaceStore
{
    NSMutableDictionary *places;
}
#pragma mark - Singleton Pattern Setup

+ (TPPlaceStore *)sharedStore {
    static TPPlaceStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[TPPlaceStore alloc] init];
    });
    
    return _sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        places = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPlaceToStore:(TPPlace *)place withTag:(NSString *)tag
{
    [places setObject:place forKey:tag];
}

- (void)removePlaceFromStoreWithTag:(NSString *)tag
{
    [places removeObjectForKey:tag];
}

- (void)uploadAllPlacesToServer
{
    
}

@end
