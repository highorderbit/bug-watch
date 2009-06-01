//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectCache.h"

@implementation ProjectCache

- (void)dealloc
{
    [projects release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        projects = [[NSMutableDictionary dictionary] retain];

    return self;
}

- (void)setProject:(Project *)project forKey:(id)key
{
    [projects setObject:project forKey:key];
}

- (Project *)projectForKey:(id)key
{
    return [[projects objectForKey:key] copy];
}

- (NSDictionary *)allProjects
{
    return [projects copy];
}

@end
