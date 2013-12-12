//
//  BCUserManager.m
//  blackcard
//
//  Created by Kosuke Hata on 12/12/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "BCUserManager.h"

@implementation BCUserManager
{
    NSMutableDictionary *users;
}

#pragma mark - Singleton Pattern Setup

+ (BCUserManager *)sharedStore {
    static BCUserManager *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[BCUserManager alloc] init];
    });
    
    return _sharedStore;
}


- (id)init {
    self = [super init];
    if (self) {
        // setup images
        users = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}


- (void)addUserToLocal:(PFUser *)user forObjectID:(NSString *)string {
    
    if ([self getUserFromLocal:string] != nil) {
        [self removeUserFromLocal:string];
    }
    [users setObject:user forKey:string];
}


- (void)removeUserFromLocal:(NSString *)objectID {
    [users removeObjectForKey:objectID];
}

// getter methods

- (PFUser *)getUserFromLocal:(NSString *)key {
    return [users objectForKey:key];
}

- (NSMutableDictionary *)getAllUsersFromLocal {
    return users;
}

#pragma mark - Internal Fetch methods

// singular return

- (void)fetchUserByObjectID:(NSString *)objectID WithCompletion:(void (^)(BOOL finished, PFObject *person))completionBlock {
    
    PFUser *localUser = [self getUserFromLocal:objectID];
    
    if (localUser == nil) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectID" equalTo:objectID];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                [users setObject:user forKey:objectID];
                
                if (completionBlock != nil) {
                    completionBlock(YES, user);
                }
            } else {
                NSLog(@"oops error at %@", self);
            }
        }];
    } else {
        completionBlock(YES, localUser);
    }
    
    
}

- (void)fetchAllUsersWithCompletion:(void (^)(BOOL finished, NSArray *people))completionBlock {
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *people, NSError *error) {
        if (!error) {
                        
            
            if (completionBlock != nil) {
                completionBlock(YES, people);
            }
        } else {
            //            NSLog(@"--------> OH NO COULD NOT GET ANYONE!");
            if (completionBlock != nil) {
                completionBlock(NO, nil);
            }
        }
    }];
}

@end
