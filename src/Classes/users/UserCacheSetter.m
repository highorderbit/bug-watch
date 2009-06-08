//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserCacheSetter.h"

@interface UserCacheSetter (Private)

- (void)setCache:(UserCache *)cache;

@end

@implementation UserCacheSetter

@synthesize cache;

- (void)dealloc
{
    [cache release];
    [super dealloc];
}

- (void)fetchedAllUsers:(NSDictionary *)users
{
    UserCache * newCache = [[[UserCache alloc] init] autorelease];
    for (id key in [users allKeys]) {
        User * user = [users objectForKey:key];
        [newCache setUser:user forKey:key];
    }
    [self setCache:newCache];
}

- (void)setCache:(UserCache *)aCache
{
    [aCache retain];
    [cache release];
    cache = aCache;
}

@end
