//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserCache.h"

@implementation UserCache

- (void)dealloc
{
    [users release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        users = [[NSMutableDictionary dictionary] retain];

    return self;
}

- (void)setUser:(User *)user forKey:(id)key
{
    [users setObject:user forKey:key];
}

- (User *)userForKey:(id)key
{
    return [users objectForKey:key];
}

- (NSDictionary *)allUsers
{
    return [users copy];
}

@end
