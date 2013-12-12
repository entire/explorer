//
//  TPUserManager.h
//  blackcard
//
//  Created by Kosuke Hata on 12/12/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TPUserManager : NSObject

+ (TPUserManager *)sharedStore;

// fetch
- (void)fetchUserByObjectID:(NSString *)objectID WithCompletion:(void (^)(BOOL finished, PFObject *user))completionBlock;
- (void)fetchAllUsersWithCompletion:(void (^)(BOOL finished, NSArray *users))completionBlock;

// get methods (local changes)
- (PFUser *)getUserFromLocal:(NSString *)objectID;
- (NSMutableDictionary *)getAllUsersFromLocal;

// add and remove methods (local changes)
- (void)addUserToLocal:(PFUser *)user forObjectID:(NSString *)string;
- (void)removeUserFromLocal:(NSString *)objectID;

@end
