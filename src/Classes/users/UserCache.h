//
//  This class is currently just a wrapper around a dictionary, but will serve
//  as a placeholder in case other attribute mappings are added
//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserCache : NSObject
{
    NSMutableDictionary * users;
}

- (void)setUser:(User *)user forKey:(id)key;
- (User *)userForKey:(id)key;
- (NSDictionary *)allUsers;

@end
