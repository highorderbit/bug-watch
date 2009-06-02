//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCache.h"

@interface UserCacheSetter : NSObject
{
    UserCache * cache;
}

@property (nonatomic, readonly) UserCache * cache;

- (void)fetchedAllUsers:(NSDictionary *)users;

@end
